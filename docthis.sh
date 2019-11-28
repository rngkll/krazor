#!/bin/bash
#
# @file docthis
# @brief Generate documentation using sphinx.

# Path to the project used as the source to generate documentation, if not
# specified the current path will be used.
PROJECT_PATH=$(pwd)

# requirements.txt file contents.
REQUIREMENTS_PIP='sphinxcontrib-restbuilder
sphinxcontrib-globalsubs
sphinx-prompt
Sphinx-Substitution-Extensions
sphinx_rtd_theme'

# conf.py file contents.
CONFIGURATION_CONTENTS='# Configuration for Sphinx documentation builder.

import os
import sys

project = "|PROJECT_GENERATED_NAME|"
copyright = "|YEAR_GENERATED_VALUE|, |AUTHOR_GENERATED_NAME|"
author = "|AUTHOR_GENERATED_NAME|"
version = "0.0.1"
release = "0.0.1"

sys.path.insert(0, os.path.abspath("../.."))

extensions = [
    "sphinxcontrib.restbuilder",
    "sphinxcontrib.globalsubs",
    "sphinx-prompt",
    "sphinx_substitution_extensions"
]

templates_path = ["_templates"]

exclude_patterns = []

html_static_path = ["_static"]

html_theme = "sphinx_rtd_theme"

master_doc = "index"

img_url = "|IMG_URL_GENERATED_VALUE|"

ci_url_base = "https://travis-ci.org/"

ci_url = ci_url_base + author + "/" + project

global_substitutions = {
    "AUTHOR_IMG": ".. image:: " + img_url +
    "/author.png\\n   :alt: author",
    "AUTHOR_SLOGAN": "The travelling vaudeville villain.",
    "CI_BADGE": ".. image:: " + ci_url + ".svg\\n   :alt: travis",
    "CI_LINK":  "`Travis CI <" + ci_url + ">`_.",
    "REPO_LINK":  "`Github repository <https://github.com/"
    + author + "/" + project + ">`_.",
    "PROJECT": project,
    "READTHEDOCS_BADGE": ".. image:: https://readthedocs.org/projects/"
    + project + "/badge\\n   :alt: readthedocs",
    "READTHEDOCS_LINK": "`readthedocs <https://" + project +
    ".readthedocs.io/en/latest/>`_."
}

substitutions = [
    ("|AUTHOR|", author),
    ("|PROJECT|", project)
]'

# .readthedocs.yml file contents.
READTHEDOCS_CONTENTS="version: 2

sphinx:
  configuration: docs/source/conf.py

python:
  version: 3.7
  install:
    - requirements: docs/requirements.txt"

# index.rst file contents.
INDEX_CONTENTS="|PROJECT_GENERATED_NAME|
=============================================================================

|CI_BADGE|

|READTHEDOCS_BADGE|

My project short description.

Full documentation on |READTHEDOCS_LINK|.

Source code on |REPO_LINK|.

Contents
=============================================================================

.. toctree::

   description

   usage

   variables

   requirements

   compatibility

   license

   links

   author

"

# description.rst file contents.
DESCRIPTION_CONTENTS='Description
-----------------------------------------------------------------------------

Describe me.'

# usage.rst file contents
USAGE_CONTENTS="Usage
-----------------------------------------------------------------------------

Download the script, give it execution permissions and execute it:

.. substitution-code-block:: bash

 wget https://raw.githubusercontent.com/|AUTHOR|/|PROJECT|/master/|PROJECT|.sh
 chmod +x |PROJECT|.sh
 ./|PROJECT|.sh -h"

# variables.rst file contents.
VARIABLES_CONTENTS="Variables
-----------------------------------------------------------------------------

The following variables are supported:

\- *-h* (help): Show help message and exit.

 .. substitution-code-block:: bash

  ./|PROJECT|.sh -h

\- *-p* (path): Optional path to project root folder.

 .. substitution-code-block:: bash

  ./|PROJECT|.sh -p /home/username/myproject"

# requirements.rst file contents.
REQUIREMENTS_CONTENTS='Requirements
-----------------------------------------------------------------------------

\- Python 3.'

# compatibility.rst file contents.
COMPATIBILITY_CONTENTS='Compatibility
-----------------------------------------------------------------------------

\- Debian buster.

\- Debian stretch.

\- Raspbian stretch.

\- Ubuntu xenial.'

# license.rst file contents.
LICENSE_CONTENTS='License
-----------------------------------------------------------------------------

MIT. See the LICENSE file for more details.'

# links.rst file contents.
LINKS_CONTENTS='Links
-----------------------------------------------------------------------------

|REPO_LINK|

|CI_LINK|'

# author.rst file contents.
AUTHOR_CONTENTS='Author
-----------------------------------------------------------------------------

|AUTHOR_IMG|

|AUTHOR_SLOGAN|'

# @description Escape especial characters.
#
# The escaped characters are:
#
#  - Period.
#  - Slash.
#  - Double dots.
#
# @arg $1 string Text to scape.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout Escaped input.
function escape() {
    [[ -z $1 ]] && echo '' && return 0
    local escaped=$(sanitize "$1")
    # Escape.
    escaped="${escaped//\./\\.}"
    escaped="${escaped//\//\\/}"
    escaped="${escaped//\:/\\:}"
    echo "$escaped"
    return 0
}

# @description Escape URLs.
#
# @arg $1 string URL to scape.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout The escaped URL plus ending slash if needed.
function escape_url() {
    [[ -z $1 ]] && echo '' && return 0
    local escaped=$(escape "$1")
    ! [[ "${escaped: -1}" == '/' ]] && escaped="$escaped\/"
    echo "$escaped"
    return 0
}

# @description Setup sphinx and generate html and rst documentation.
#
# @arg $1 string Optional project path. Default to current path.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout *README-single* rst on project's root directory.
function generate() {

    local project_path=$(pwd)
    [[ -d $1 ]] && project_path="$( cd "$1" ; pwd -P )"

    local author=$(get_author $project_path)

    local project=$(get_project $project_path)

    local project_year=$(date +"%Y")

    local img_url=$(get_img_url $project_path)

    # Setup everything for new projects.
    if ! [[ -f $project_path/docs/source/conf.py ]]; then

        # Directory layout.
        mkdir -p $project_path/docs/source/_static &>/dev/null
        mkdir -p $project_path/docs/source/_templates &>/dev/null
        mkdir -p $project_path/docs/build/html &>/dev/null
        mkdir -p $project_path/docs/build/rst &>/dev/null
                    
        # Create .readthedocs.yml configuration file.
        if ! [[ -f $project_path/.readthedocs.yml ]]; then
            printf "$READTHEDOCS_CONTENTS" > $project_path/.readthedocs.yml
        fi

        # Copy docthis.sh if not exists.
        if ! [[ -f $project_path/docthis.sh ]]; then
            cp "$( cd "$(dirname "$0")" ; pwd -P )"/docthis.sh $project_path/docthis.sh
        fi

        # Create requirements.txt file.
        if ! [[ -f $project_path/docs/requirements.txt ]];
        then
            printf "$REQUIREMENTS_PIP" > $project_path/docs/requirements.txt
        fi

        # Create conf.py file.
        if ! [[ -f $project_path/docs/source/conf.py ]];
        then
            printf "$CONFIGURATION_CONTENTS" > $project_path/docs/source/conf.py
        fi

        # Create source files.
        if ! [[ -f $project_path/docs/source/index.rst ]]; then
            printf "$INDEX_CONTENTS" > $project_path/docs/source/index.rst
            printf "$DESCRIPTION_CONTENTS" > $project_path/docs/source/description.rst
            printf "$USAGE_CONTENTS" > $project_path/docs/source/usage.rst
            printf "$VARIABLES_CONTENTS" > $project_path/docs/source/variables.rst
            printf "$REQUIREMENTS_CONTENTS" > $project_path/docs/source/requirements.rst
            printf "$COMPATIBILITY_CONTENTS" > $project_path/docs/source/compatibility.rst
            printf "$LICENSE_CONTENTS" > $project_path/docs/source/license.rst
            printf "$LINKS_CONTENTS" > $project_path/docs/source/links.rst
            printf "$AUTHOR_CONTENTS" > $project_path/docs/source/author.rst
            sed -i -E "s/\|AUTHOR_GENERATED_NAME\|/$author/g" $project_path/docs/source/*.*
            sed -i -E "s/\|PROJECT_GENERATED_NAME\|/$project/g" $project_path/docs/source/*.*
            sed -i -E "s/\|YEAR_GENERATED_VALUE\|/$project_year/g" $project_path/docs/source/*.*
            sed -i -E "s/\|IMG_URL_GENERATED_VALUE\|/$(escape_url $img_url)/g" $project_path/docs/source/*.*
        fi

        # Install requirements if not already installed.
        local sphinx_requirements=$(python3 -m pip list --format=columns)
        sphinx_requirements="${sphinx_requirements,,}"
        sphinx_requirements="${sphinx_requirements//-/_}"
        local current_line=''
        while read LINE
        do
            current_line=$LINE
            current_line="${current_line,,}"
            current_line="${current_line//-/_}"
            ! [[ $sphinx_requirements == *"$current_line"* ]] && python3 -m pip install $LINE
        done < $project_path/docs/requirements.txt

    fi # New project?.

    # Generate documentation.
    python3 -m sphinx -b html $project_path/docs/source/ $project_path/docs/build/html
    generate_rst $project_path

    return 0
}

# @description Generate rst documentation using sphinx.
#
# This function will extract each filename to include from the index.rst file
# and concatenate all files into a single README-single.rst file.
#
# This function assumes:
#   - The project has a file structure as created by generate().
#   - The index.rst file contains a blank new line at the end.
#   - The index.rst file contains the :toctree: directive.
#
# @arg $1 string Optional project path. Default to current path.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout *README-single* rst on project's root directory.
function generate_rst() {

    local project_path=$(pwd)
    [[ -d $1 ]] && project_path="$( cd "$1" ; pwd -P )"

    local project=$(get_project $project_path)

    local author=$(get_author $project_path)

    # When a line readed from the index.rst file is a menu item,
    # this variable will be setted to true.
    # This is a flag to indicate if we found the items to
    # include on the resulting README file when reading the source index file.
    local items_found=false

    # Clean files first.
    rm -r $project_path/docs/build/rst/*.rst &>/dev/null

    python3 -m sphinx -b rst $project_path/docs/source/ $project_path/docs/build/rst

    # Recreate the file to append content.
    if [[ -f $project_path/docs/build/rst/index.rst ]]; then
       readthedocs_to_rst $project_path/docs/build/rst/index.rst $project_path
       cat $project_path/docs/build/rst/index.rst > $project_path/README-single.rst
       printf '\n' >> $project_path/README-single.rst
    fi

    while read LINE
    do
        # The directive :toctree: of the index.rst file
        # activates the search for menu item lines within that file.
        [[ $LINE == *'toctree::'* ]] && items_found=true && continue

        if [[ $items_found == true ]] && ! [[ -z "$LINE"  ]]; then

            # Apply conversion from readthedocs to common rst.
            readthedocs_to_rst $project_path/docs/build/rst/${LINE}.rst $project_path

            if [[ -f $project_path/docs/build/rst/${LINE}.rst ]]; then
                cat $project_path/docs/build/rst/${LINE}.rst >> $project_path/README-single.rst
                printf "\n" >> $project_path/README-single.rst
            fi

        fi

    done < $project_path/docs/source/index.rst

    return 0
}

# @description Get the author's name.
#
# @arg $1 string Optional project path. Default to current path.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout echo author's name.
function get_author() {

    local project_path=$(pwd)
    [[ -d $1 ]] && project_path="$( cd "$1" ; pwd -P )"

    local author=$(get_variable 'author' $project_path)
    ! [[ -z $author ]] && echo $author && return 0

    whoami && return 0

}

# @description Get the images repository URL.
#
# This function assumes:
#   - The project has a file structure as created by generate().
#
# @arg $1 string Optional project path. Default to current path.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout echo repository images URL.
function get_img_url() {

    local project_path=$(pwd)
    [[ -d $1 ]] && project_path="$( cd "$1" ; pwd -P )"
    local img_url=$(get_variable 'img_url' $project_path)
    if ! [[ -z "$img_url" ]]; then
        escape_url $img_url
        return 0
    fi
    local author=$(get_author $project_path)
    local project=$(get_project $project_path)
    echo "https://raw.githubusercontent.com/$author/$project/master/img/"
    return 0

}

# @description Get the continuous integration repository URL.
#
# This function assumes:
#   - The project has a file structure as created by generate().
#
# @arg $1 string Optional project path. Default to current path.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout echo continuous integration URL.
function get_ci_url() {

    local project_path=$(pwd)
    [[ -d $1 ]] && project_path="$( cd "$1" ; pwd -P )"
    local ci_url=$(get_variable 'ci_url' $project_path)
    if ! [[ -z "$ci_url" ]]; then 
        escape_url $ci_url
        return 0
    fi
    local author=$(get_author $project_path)
    local project=$(get_project $project_path)
    echo "https://travis-ci.org/$author/$project/"
    return 0

}

# @description Get a images or continuous integration URL.
#
# This function assumes:
#   - The project has a file structure as created by generate().
#
# @arg $1 string Required variable name.
# @arg $2 string Optional project path. Default to current path.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout echo URL.
function get_variable() {

    [[ -z $1 ]] && return 1
    local variable_name=$1

    local project_path=$(pwd)
    [[ -d $2 ]] && project_path="$( cd "$2" ; pwd -P )"

    local variable_value=$(get_variable_from_conf $variable_name $project_path)

    if ! [[ -z $variable_value ]]; then
        if [[ "$variable_value" =~ 'author' ]]; then
            if ! [[ -z $author ]]; then
                variable_value="${variable_value//author/$author}"
            fi
        fi

        if [[ "$variable_value" =~ 'project' ]]; then
            if ! [[ -z $project ]]; then
                variable_value="${variable_value//project/$project}"
            fi
        fi

        if [[ "$variable_value" =~ 'img_url' ]] &&
               ! [[ "$variable_value" =~ 'img_url_base' ]] &&
               ! [[ "$variable_value" =~ 'img_url_part' ]]; then
            local img_url=$(get_variable 'img_url' $project_path)
            if ! [[ -z $img_url_base ]]; then
                variable_value="${variable_value//img_url/$img_url}"
            fi
        fi

        if [[ "$variable_value" =~ 'img_url_base' ]]; then
            local img_url_base=$(get_variable 'img_url_base' $project_path)
            if ! [[ -z $img_url_base ]]; then
                variable_value="${variable_value//img_url_base/$img_url_base}"
            fi
        fi

        if [[ "$variable_value" =~ 'img_url_part' ]]; then
            local img_url_part=$(get_variable 'img_url_part' $project_path)
            if ! [[ -z $img_url_part ]]; then
                variable_value="${variable_value//img_url_part/$img_url_part}"
            fi
        fi

        if [[ "$variable_value" =~ 'ci_url_base' ]]; then
            local ci_url_base=$(get_variable 'ci_url_base' $project_path)
            if ! [[ -z $ci_url_base ]]; then
                variable_value="${variable_value//ci_url_base/$ci_url_base}"
            fi
        fi

        # Remove '+'.
        variable_value="${variable_value//+/\/}"
        # Remove quotes.
        variable_value="${variable_value//\"/}"
        variable_value="${variable_value//\'/}"
        variable_value=$(sanitize "$variable_value")
        echo $variable_value && return 0
    fi

    echo ''
    return 0

}

# @description Get the project's name.
#
# @arg $1 string Optional project path. Default to current path.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout echo project's name.
function get_project() {

    local project_path=$(pwd)
    [[ -d $1 ]] && project_path="$( cd "$1" ; pwd -P )"

    local project=$(get_variable 'project' $project_path)
    if [ $? -eq 0 ]; then
        ! [[ -z $project ]] && echo $project && return 0
    fi

    basename $project_path && return 0

}

# @description Get bash parameters.
#
# Accepts:
#
#  - *h* (help).
#  - *p* <path> (project_path).
#
# @arg '$@' string Bash arguments.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
function get_parameters() {

    # Obtain parameters.
    while getopts 'h;p:' opt; do
        OPTARG=$(sanitize "$OPTARG")
        case "$opt" in
            h) help && exit 0;;
            p) PROJECT_PATH="${OPTARG}";;
        esac
    done

    return 0
}

# @description Get a variable from the configuration file.
#
# @arg $1 string Required variable name.
# @arg $2 string Optional project path. Default to current path.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout echo variable value.
function get_variable_from_conf() {

    [[ -z $1 ]] && return 1
    local variable_name=$1

    local project_path=$(pwd)
    [[ -d $2 ]] && project_path="$( cd "$2" ; pwd -P )"
    ! [[ -f $project_path/docs/source/conf.py ]] && echo '' && return 0

    local variable_value=''

    if [[ "$variable_name" == 'img_url' ]] ||
           [[ "$variable_name" == 'ci_url' ]]; then 
        variable_value=$(get_variable_line "$variable_name" "$project_path")

    else
        variable_value=$(cat $project_path/docs/source/conf.py | sed -n "s/^.*${variable_name}\s*\=\s*\(\S*\)\s*.*$/\1/p")
    fi

    # Remove quotes.
    variable_value="${variable_value//\"/}"
    variable_value="${variable_value//\"/}"
    variable_value="${variable_value//\'/}"
    variable_value="${variable_value//\'/}"
    echo $variable_value
    return 0
}

# @description Get a variable line from the configuration file.
#
# @arg $1 string Required variable name.
# @arg $2 string Optional project path. Default to current path.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout echo variable value.
function get_variable_line() {

    [[ -z $1 ]] && return 1
    local variable_name=$1

    local project_path=$(pwd)
    [[ -d $2 ]] && project_path="$( cd "$2" ; pwd -P )"
    ! [[ -f $project_path/docs/source/conf.py ]] && return 1

    local variable_value=''
    variable_value=$(grep "$variable_name =" $project_path/docs/source/conf.py)
    # Remove spaces.
    variable_value="${variable_value//\ /}"
    # Remove variable_name=.
    variable_value="${variable_value//$variable_name=/}"
    echo "$variable_value"
    return 0
    
}

# @description Shows help message.
#
# @noargs
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
function help() {

    echo 'Uses Sphinx to generate html and rst documentation.'
    echo 'Parameters:'
    echo '-h (help): Show this help message.'
    echo '-p <file_path> (project path): Optional absolute file path to the
             root directory of the project to generate documentation. If this
             parameter is not espeficied, the current path will be used.'
    echo 'Example:'
    echo "./docthis.sh -p /home/username/my_project"
    return 0

}

# @description Generate documentation using sphinx.
#
# @arg $@ string Bash arguments.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
function main() {

    get_parameters "$@"

    generate "$PROJECT_PATH"
 
    return 0
}

# @description Replace reference from readthedocs format to standard rst.
#
# See `this link <https://github.com/constrict0r/images>`_ for an example
# images repository.
#
# @arg $1 string Path to file where to apply replacements.
# @arg $2 string Optional project path. Default to current path.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout Modified passed file.
function readthedocs_to_rst() {

    ! [[ -f $1 ]] && return 1

    local project_path=$(pwd)
    [[ -d $2 ]] && project_path="$( cd "$2" ; pwd -P )"

    local author=$(get_author $project_path)

    local project=$(get_project $project_path)

    local img_url=$(get_img_url $project_path)

    local ci_url=$(get_ci_url $project_path)

    # Convert all `<text.rst>`_ references to `<#text>`.
    sed -i -E "s/\<([[:alpha:]]*[[:punct:]]*)+\.rst\>//g" $1
    sed -i -E 's/([[:alpha:]]+)\ <>/\1\ <#\1>/g' $1

    # Replace travis-ci status badge image.
    sed -i -E "s@\[image\:\ travis\]\[image\]@\.\.\ image\:\:\ $ci_url\.svg\\n   :alt: travis@g" $1

    # Replace gitlab-ci status badge image.
   sed -i -E "s@\[image\:\ pipeline\]\[image\]@\.\.\ image\:\:\ https\:\/\/gitlab\.com\/$author/$project\/badges\/master\/pipeline\.svg\\n   :alt: pipeline@g" $1

    # Replace readthedocs status badge image.
    sed -i -E "s@\[image\:\ readthedocs\]\[image\]@\.\.\ image\:\:\ https\:\/\/readthedocs\.org\/projects\/$project\/badge\\n   :alt: readthedocs@g" $1

    # Replace coverage status badge image on github using coveralls.
    if [[ "$ci_url" =~ 'github' ]]; then
        sed -i -E "s@\[image\:\ coverage\]\[image\]@\.\.\ image\:\:\ https\:\/\/coveralls\.io\/repos\/github\/$author\/$project\/badge\.svg\\n   :alt: coverage@g" $1

    # Replace coverage status badge image on gitlab.
    else
        sed -i -E "s@\[image\:\ coverage\]\[image\]@\.\.\ image\:\:\ https\:\/\/gitlab\.com\/$author\/$project\/badges\/master\/coverage\.svg\\n   :alt: coverage@g" $1

    fi

    # Replace rest of images.
    sed -i -E "s@\[image\:\ (.*)+\]\[image\]@\.\.\ image\:\:\ $img_url\1\.png\\n   :alt: \1@g" $1

    return 0
}

# @description Sanitize input.
#
# The applied operations are:
#
#  - Trim.
#
# @arg $1 string Text to sanitize.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure.
#
# @stdout Sanitized input.
function sanitize() {
    [[ -z $1 ]] && echo '' && return 0
    local sanitized="$1"
    # Trim.
    sanitized="${sanitized## }"
    sanitized="${sanitized%% }"
    echo "$sanitized"
    return 0
}

# Avoid running the main function if we are sourcing this file.
return 0 2>/dev/null
main "$@"
