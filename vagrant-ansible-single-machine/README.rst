
=====================================================
Using Ansible with a single Vagrant box
=====================================================

This project is an example for using *Ansible* with a *single* Vagrant
machine. This project is the result of researching how to work with
Debops and Vagrant and shows that this is not the way to go.

If you want to use Debops and Vagrant, we suggest you have a look at
the other examples.


Requirements
==============

* Ansible
* Vagrant 1.6 or newer (1.5 may work, too; 1.4 does not)


Quick Start
===========

* Fire up Vagrant: ``vagrant up``

  This will create a virtual machine `web` and run a simple playbook
  testing if some variables have been set up correctly. Since there
  are only one host and one group defined, you should get one
  "skipped" message.


How it works
==============

`vagrant` will generate an inventory-file somewhere `.vagrant/` (you
do not need to care). This inventory will be set up with the data
specified in the `Vagrantfile`. When running the Ansible provisioner,
this inventory is passed to `ansible-playbook`.

In addition, the Vagrantfile will symlink some files or directories
from `ansible/inventory` to the auto-generated inventory.


Adopting to your needs
=========================

In short:

- Set up your host and group-vars in `ansible/inventory` as usual.
- The playbook the provisioner runs is set in the Vagrantfile
  (:var:`ANSIBLE_PLAYBOOK`).
- If you need more parts symlink to the auto-generated inventory, add
  them to :var:`INVENTORY_PARTS`.


Some notes
================

* About the vagrant Ansible provisioner:

  - If `ansible.inventory_path` is set, the provisioner will not
    generate an inventory file. You will have to take care of this by
    yourself.
  - The path in `ansible.inventory_path`, if given, must already exist.
  - The executable is hard-coded to `ansible-playbook`.


Alternative setup
=====================


Using a hand crafted inventory
-------------------------------

If for some reason you prefer to craft the inventory yourself
(instead of letting vagrant generate it) you can pass your inventory
to the Ansible provisioner in the `Vagrantfile`. See the commented out
example in he supplied Vagrantfile. Or course, the argument can be
anything `ansible-playbook` will accept as an inventory: a file, a
directory or some executable.


..
 Local Variables:
 mode: rst
 ispell-local-dictionary: "american"
 End:
