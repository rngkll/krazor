
krazor
******

.. image:: https://gitlab.com/rngkll/krazor/badges/master/pipeline.svg
   :alt: pipeline

.. image:: https://readthedocs.org/projects/krazor/badge
   :alt: readthedocs

`Ansible <https://www.ansible.com/>`_ to apply hardware provisioning.

Full documentation on `readthedocs
<https://krazor.readthedocs.io/en/latest/>`_.

Source code on `Repository
<https://gitlab.com/rngkll/ansible-role-krazor>`_.


Contents
********

* `Description <#Description>`_
* `Usage <#Usage>`_
* `Variables <#Variables>`_
   * `upgrade <#upgrade>`_
   * `configuration <#configuration>`_
* `YAML <#YAML>`_
* `Requirements <#Requirements>`_
* `Compatibility <#Compatibility>`_
* `License <#License>`_
* `Links <#Links>`_
* `UML <#UML>`_
   * `Deployment <#deployment>`_
   * `Main <#main>`_
* `Author <#Author>`_

Description
***********

Hardware provisioning for razor.


Usage
*****

* To install and execute:

..

   ::

      ansible-galaxy install rngkll.krazor
      ansible localhost -m include_role -a name=rngkll.krazor -K

* Passing variables:

..

   ::

      ansible localhost -m include_role -a name=rngkll.krazor -K \
          -e "upgrade: false"

* To include the role on a playbook:

..

   ::

      - hosts: servers
        roles:
            - {role: rngkll.krazor}

* To include the role as dependency on another role:

..

   ::

      dependencies:
        - role: rngkll.krazor
          upgrade: true

* To use the role from tasks:

..

   ::

      - name: Execute role task.
        import_role:
          name: rngkll.krazor
        vars:
          upgrade: true

* To run tests:

..

   ::

      cd krazor
      chmod +x testme.sh
      ./testme.sh

   On some tests you may need to use *sudo* to succeed.


Variables
*********

The following variables are supported:


upgrade
=======

Boolean variable that defines if a system full upgrade is performed or
not.

If set to *true* a full system upgrade is executed.

This variable is set to *true* by default.

::

   # Including from terminal.
   ansible localhost -m include_role -a name=rngkll.krazor -K -e \
       "upgrade=false"

   # Including on a playbook.
   - hosts: servers
     roles:
       - role: rngkll.krazor
         upgrade: false

   # To a playbook from terminal.
   ansible-playbook -i tests/inventory tests/test-playbook.yml -K -e \
       "upgrade=false"


configuration
=============

Absolute file path or URL to a *.yml* file that contains all or some
of the variables supported by this role.

It is recommended to use a *.yml* or *.yaml* extension for the
**configuration** file.

This variable is empty by default.

::

   # Using file path.
   ansible localhost -m include_role -a name=rngkll.krazor -K -e \
       "configuration=/home/username/my-config.yml"

   # Using URL.
   ansible localhost -m include_role -a name=rngkll.krazor -K -e \
       "configuration=https://my-url/my-config.yml"

To see how to write  a configuration file see the *YAML* file format
section.


YAML
****

When passing configuration files to this role as parameters, it’s
recommended to add a *.yml* or *.yaml* extension to the each file.

It is also recommended to add three dashes at the top of each file:

::

   ---

You can include in the file the variables required for your tasks:

::

   ---
   upgrade:
     - true

If you want this role to load list of items from files and URLs you
can set the **expand** variable to *true*:

::

   ---
   upgrade: /home/username/my-config.yml

   expand: true

If the expand variable is *false*, any file path or URL found will be
treated like plain text.


Requirements
************

* Ansible >= 2.8.

* `Jinja2 <https://palletsprojects.com/p/jinja/>`_.

* `Python <https://www.python.org/>`_.

If you want to run the tests, you will also need:

* `Docker <https://www.docker.com/>`_.

* `Molecule <https://molecule.readthedocs.io/>`_.

* `Setuptools <https://pypi.org/project/setuptools/>`_.


Compatibility
*************

* `Debian Buster <https://wiki.debian.org/DebianBuster>`_.

* `Debian Raspbian <https://raspbian.org/>`_.

* `Debian Stretch <https://wiki.debian.org/DebianStretch>`_.

* `Ubuntu Xenial <http://releases.ubuntu.com/16.04/>`_.


License
*******

MIT. See the LICENSE file for more details.


Links
*****

* `Repository <https://gitlab.com/rngkll/ansible-role-krazor>`_.

* `readthedocs <https://krazor.readthedocs.io/en/latest/>`_.


UML
***


Deployment
==========

The full project structure is shown below:

.. image:: https://gitlab.com//rngkll/ansible-role-krazor/raw/master/img/deployment.png
   :alt: deployment


Main
====

The project data flow is shown below:

.. image:: https://gitlab.com//rngkll/ansible-role-krazor/raw/master/img/main.png
   :alt: main


Author
******

.. image:: https://gitlab.com//rngkll/ansible-role-krazor/raw/master/img/author.png
   :alt: author

Jaquerespeis.

