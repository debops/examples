
=====================================================
Using Ansible with a single Vagrant box
=====================================================

This project is an example for using Ansible with a *single*
Vagrant box. This project does not show how to work with debops and
Vagrant, so one may consider it a research project.

Please note: If you want to configure several boxes in the same
Vagrantfile, you should take a different approach, see the other
Vagrant examples.


Requirements
==============

* Ansible
* Vagrant 1.6 or newer (1.5 may work, too; 1.4 does not)
* `debops` (of course ;-)


Quick Start
===========

* Fire up Vagrant: `vagrant up`

  This will create a virtual machine `web` and run a simple playbook
  testing if some variables have been set up correctly. Since there
  are only one host and one group defined, should get one "skipped"
  message.

* Run `debops`

  This will create a virtual machine `web` and deploy nginx, gitusers
  and nodejs within. You should be able to access the web-site running
  on this machine by pointing your browsers to http:/...



How it works
==============


`vagrant` will generate an inventory-file somewhere `.vagrant/` (you
do not need to care). This inventory will be set up with the data
specified in the `Vagrantfile`. When running the ansible provisioner,
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

* About the vagrant ansible provisioner:
  - If `ansible.inventory_path` is set, the provider will not
    generate an inventory file. You will have to take care of this by
    yourself.
  - The path in `ansible.inventory_path`, if given, must already exist.
  - The executable is hard-coded to `ansible-playbook`.

`debops` created :file:`ansible.cfg` which points to directory
`ansible/inventory`.

`vagrant` will generate an inventory-file somewhere `.vagrant/` (you
do not need to care). This inventory will be sett up with the data
specified in the `Vagrantfile`. When running the ansible provisioner,
this inventory-file is passed to `ansible-playbook`.

Now `ansible-playbook` will read all files in `ansible/inventory` *and*
the inventory file (the later is overriding the former [1][2])[3]

About the vagrant ansible provisioner:
- If `ansible.inventory_path` is set, the provider will not
  generate a auto-generate an inventory file.
- The path in `ansible.inventory_path`, if given, must already exist.
- The executable is hard-coded to `ansible-playbook`.


Caveeats
=============

* When setting of the boxes the "normal" way, vagrant will run
  ansible-playbook once for each box. When setting ``ansible.limit =
  'all'`` Vagrant will run ansible-playbook for *all* boxes, but so
  many times as you have defined boxes.

* One can design the Vagrantfile *very* carfully (see
  `<https://github.com/mitchellh/vagrant/issues/1784#issuecomment-62460418
  this comment>`_) so the provisioner will only be attached to the
  *last* machine. Now when setting ``ansible.limit ='all'`` `vagrant`
  will run ansible-playbook once and only once on all machines.

  But this agin has a downside: ``vagrant provision firstMachine``
  does not work for all machines except the last.

Support parallel multi-machine provisioning using Ansible



Alternative setup
=====================


Using a hand crafted inventory
-------------------------------

If for some reason you prefer to craft the inventory yourself
(instead of letting vagrant generate it) you can pass your inventory
to the ansible provisioner in the `Vagrantfile`. See the commented out
example in he supplied Vagrantfile. Or course, the argument can be
anything `ansible-playbook` will accept as an inventory: a file, a
directory or some executable.

Please mind: If you have a `ansible.cfg` in place, e.g. as generated
by `debops`, this may define an additional inventory which may
interfere with yours.
