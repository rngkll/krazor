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

img_url_base = "https://gitlab.com/"

img_url_part = "ansible-role-krazor/raw/master/img/"

img_url = img_url_base + author + img_url_part

ci_url_base = "https://gitlab.com/"

ci_url = ci_url_base + author + "/ansible-role-krazor/pipelines"

global_substitutions = {
    "AUTHOR_IMG": ".. image:: " + img_url + "author.png\n   :alt: author",
    "AUTHOR_SLOGAN": "Jaquerespeis.",
    "CI_BADGE": ".. image:: " + img_url_base + author
    + "ansible-role-krazor/badges/master/pipeline.svg\n :alt: pipeline",
    "CI_LINK": "`Gitlab CI <" + ci_url + ">`_",
    "DEFAULT_VAR_NAME": 'upgrade',
    "DEPLOYMENT_IMG": ".. image:: " + img_url
    + "deployment.png\n   :alt: deployment",
    "REPO_LINK":  "`Gitlab repository <https://gitlab.com/"
    + author + "/ansible-role-krazor>`_.",
    "MAIN_IMG": ".. image:: " + img_url + "main.png\n   :alt: main",
    "PROJECT": project,
    "READTHEDOCS_BADGE": ".. image:: https://readthedocs.org/projects/"
    + project + "/badge\n   :alt: readthedocs",
    "READTHEDOCS_LINK": "`readthedocs <https://" + project +
    ".readthedocs.io/en/latest/>`_.",
}

substitutions = [
    ("|AUTHOR|", author),
    ("|DEFAULT_ROLE_VARS|", '-e "upgrade: false"'),
    ("|DEFAULT_VAR_NAME|", 'upgrade'),
    ("|DEFAULT_VAR_VALUE|", 'true'),
    ("|PROJECT|", project)
]
