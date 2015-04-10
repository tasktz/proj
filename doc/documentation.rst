============================================
Documentation for Riak CS installation task
============================================

By: Tomasz Zaleski <tzaleski@gmail.com>

Date: 2015-04-09 23:00

Ver: 0.1

.. contents::

Task 
================

Objective
------------

Deploy a Riak CS cluster of 3 or more nodes connected through a OpenVSwitch
defined network to a client node. Everything has to be installed in an
automated way.

Expected outcome
------------------------------

- Fully automated deployment of the Riak cluster
- Details on how the servers were hardened
- Documentation
- Open problems and next steps

General rules
------------------

- Servers accept only secure connections
- Servers only communicate through secure connections
- Servers must be as hardened as possible
- Documentation needs to be created. The quality of the documentation must be on the level that it could be handed over to an other DevOps Engineer without having to talk to the person.
- How-to guide needs to be created that is clearly structured

My solution
=============

Use Vagrant, Puppet, Ubuntu to achieve the goal.

Hardware config
-----------------

During the task time frame I only had access to a laptop with Windows. 
I have used VMware Workstation where I have installed xubuntu-14.04-desktop-amd64. 

Software
--------------

Basically all I have used was:

- Ubuntu 14.04 as an operating system
- Vagrant to manage vms
- Puppet to set up software
- Docutils to render rst documentation into html 
- Git as a version control system
- Vim as an editor of choice

Installation
===============

Requirements
----------------

- Ubuntu 14.04 box capable of hosting 3 Riak vms
- Access to Vagrant ubuntu/trusty64 image, Ubuntu standard repositories, Riak, Riak CS, Stanchion packages


Setup
--------------

1. Install Ubuntu 14.04 box (hostname u01)
2. Update u01 packages list

.. code-block:: bash 

    root@u01:~# /usr/bin/apt-get -y update

3. Install git and puppet

.. code-block:: bash 
    
    root@u01:~# /usr/bin/apt-get -y install git puppet

4. Clone configuration repository into /root/proj directory

.. code-block:: bash 

    root@u01:~# cd /root && git clone https://github.com/tasktz/proj.git

5. Apply configuration for u01

.. code-block:: bash 

    root@u01:~/proj# puppet apply /root/proj/puppet/manifests/site.pp 

This step will:

- install openvswitch-switch, virtualbox, vagrant and vim packages. 
- install vagrant-vbguest Vagrant plugin
- set up openvswitch bridge rbridge (with ip address 192.168.233.100 and default gateway 192.168.233.2)
- create 3 network interfaces: vport1, vport2 and vport3 and add them to rbridge

Riak CS installation
----------------------

1. Deploy Riak vms

.. code-block:: bash 

    root@u01:~# cd /root/proj && vagrant up

This step will create 3 vms: 

- riak1 (eth1 ip address 192.168.233.101/24) - first node with Stanchion, Riak and Riak CS
- riak2 (eth1 ip address 192.168.233.102/24) and riak3 (eth1 ip address 192.168.233.103/24) - nodes with Riak and Riak CS

eth0 interface is NAT-ed with u01 for Vagrant management, eth1 interface is bridged with vport1 on riak1 vm, vport2 on riak2 vm and vport3 on riak3 vm.


TODO
============

Configure the Riak cluster
----------------------------

Riak, Riak CS and Stanchion were not configured.

Adjust Vagrant's Ubuntu image for production environment
----------------------------------------------------------

- Replace ssh keys in the Vagrant image for self created
- Change default passwords
- Use multiple and dedicated disk partitions

Harden operating system
--------------------------

- Disallow root to log in via ssh, use only key-based authentication
- Use sudo instead of su
- Set up NTP
- Disable unnecessary services
- Set up firewall rules (iptables/ufw)
- Log to remote host
- Harden network via sysctl
- Set default to deny in tcp wrappers
- Limit users via limits.conf
- Add security mount options (like nosuid, noexec) to fstab
- Use integrity check software (AIDE/tripwire)
- Set up AppArmor
 
Next steps
-------------

- Set up backup
- Set up monitoring
- Improve high availability

Issues
========

- Nested virtualization is very very slow
