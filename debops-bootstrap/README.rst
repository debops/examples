
================================================
Bootstrap and run DebOps on a single Vagrant box
================================================

This project is an example for using the Vagrant Ansible provisioner
bootstraping a DebOps master server and then running ``debops`` on
itself.


Requirements
============

* Ansible
* Vagrant 1.8 or newer


Quick Start
===========

* Fire up Vagrant: ``vagrant up``

  This will create a virtual machine ``master`` and run a playbook
  which will build and install Ansible, install DebOps, upload
  the inventory generated from the ``Vagrantfile`` and eventually
  run ``debops``.


How it works
============

Vagrant will first download the ansible-debops_ role which is later
used to install DebOps in the virtual machine. Then it will spin up
a Debian box and runs the Ansible provisioner with the provided
bootstrap-debops.yml_ playbook. The Ansible inventory and variable
definitions are set in the ``Vagrantfile`` and forwarded to the
provisioner. After DebOps is installed the generated inventory file
is uploaded to the virtual machine and used as input to ``debops`` itself.

.. _ansible-debops: https://github.com/debops/ansible-debops
.. _bootstrap-debops.yml: https://github.com/debops/examples/blob/master/bootstrap-debops/bootstrap-debops.yml


Adopting to your needs
======================

In short:

- Add the host to any DebOps hostgroup you like to run additional
  roles
- Set any role variable in the ``Vagrantfile`` to adjust the DebOps
  configuration (follow the ``dhparam_bits`` example)
- If you want to configure and run ``debops`` interactively set
  ``vagrant_upload_inventory`` and ``vagrant_run_debops`` in the
  ``Vagrantfile`` to ``False``.


..
 Local Variables:
 mode: rst
 ispell-local-dictionary: "american"
 End:
