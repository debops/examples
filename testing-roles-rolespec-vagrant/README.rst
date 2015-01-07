
=====================================================
Testing roles using rolespec in a virtual machine
=====================================================

This project is an example for how to test roles while developing
them.

`rolespec`_ is a great tool for developing and testing roles. Please
read the `rolespec` documentation for more insight. One thing the
documentation does not cover is how to set up a development
environment for it. This is where this example comes in.

.. Note::

  As of 2015-01-07 nickjj's rolespec does not include the required
  support for `.rolespec.cfg`. Meanwhile please use this fork:
  https://github.com/htgoebel/rolespec



Requirements
==============

* Ansible
* `rolespec`_
* Vagrant


Quick Start
===========

* Adopt the enclosed ``Vagrantfile`` to your needs. Esp. you need to
  adopt the path mapping near the end of the file to match your
  directory layout (see below)

* Fire up Vagrant ``vagrant up`` and log into the Vagrant host:
  ``vagrant ssh``.

* On the Vagrant host, run your tests, e.g::

    cd /vargrant
    rolespec -l openvpn      # lint the openvpn-role
    rolespec -r openvpn      # run the tests for the openvpn-role
    rolespec -r openvpn -p   # run the tests in "playbook mode"


Directory Layout
===================

`rolespec` normally assumes this directory layout::

  /path/to/where/your/projects/are   # <--- working dir
  ├── roles
  │   ├── ansible-role1
  │   └── debops.role42
  └── tests
      ├── ansible-role1
      └── debops.role42


The files as contained in this directory assumes this directory
layout::

  /path/to/where/your/projects/are
  └── roles
      ├── ansible-role1
      ├── debops.role42
      └── test-suite                # <--- working dir
          ├── ansible-role1
          └── debops.role42

This is a layout I personally prefer. Your preferences may vary and
adopting the configuration-files to your needs should be easy.


Using your test-suite with travis
===================================

Using this test-suite with travis should be easy: The
configuration-files test if running under travis and adopt
settings. So you should be able to push your test-suite to github and
have travis running it without changes.


.. _rolespec: https://github.com/nickjj/rolespec

..
 Local Variables:
 mode: rst
 ispell-local-dictionary: "american"
 End:
