# Configuration file for the Sphinx documentation builder.

import os
import sys

project = "krazor"
copyright = "2019, jaquerespeis"
author = "rngkll"
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

img_url_base = "https://raw.githubusercontent.com/"

img_url_repo = "/images/master/"

images_url = img_url_base + author + img_url_repo + project

global_substitutions = {
    "AUTHOR_IMAGE": ".. image:: " + images_url +
    "/author.png\n   :alt: author",
    "AUTHOR_SLOGAN": "Jaquerespeis.",
    "DEFAULT_VAR_NAME": 'upgrade',
    "DEPLOYMENT_IMAGE": ".. image:: " + images_url +
    "/deployment.png\n   :alt: deployment",
    "ENJOY_IMAGE": ".. image:: " + images_url + "/enjoy.png\n   :alt: enjoy",
    "GITHUB_REPO_LINK":  "`Github repository <https://github.com/"
    + author + "/" + project + ">`_.",
    "MAIN_IMAGE": ".. image:: " + images_url +
    "/main.png\n   :alt: main",
    "PROJECT": project,
    "READTHEDOCS_IMAGE": ".. image:: https://readthedocs.org/projects/"
    + project + "/badge\n   :alt: readthedocs",
    "READTHEDOCS_LINK": "`readthedocs <https://" + project +
    ".readthedocs.io/en/latest/>`_.",
    "TRAVIS_CI_IMAGE": ".. image:: https://api.travis-ci.org/" + author +
    "/" + project + ".svg\n   :alt: travis",
    "TRAVIS_CI_LINK":  "`Travis CI <https://travis-ci.org/"
    + author + "/" + project + ">`_.",
}

substitutions = [
    ("|AUTHOR|", author),
    ("|DEFAULT_ROLE_VARS|", '-e "upgrade: false"'),
    ("|DEFAULT_VAR_NAME|", 'upgrade'),
    ("|DEFAULT_VAR_VALUE|", 'true'),
    ("|PROJECT|", project)
]
