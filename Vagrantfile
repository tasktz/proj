# -*- mode: ruby -*-
# vi: set ft=ruby :

#By: Tomasz Zaleski <tzaleski@gmail.com>
#Date: 2015-04-09 23:00
#Ver: 0.1


VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  #config.vm.box_url = "http://192.168.233.209/iso/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.boot_timeout = 1200

  #config.ssh.private_key_path = "my_new_ssh_key"
  #config.ssh.forward_agent = true

  config.vm.define "riak1" do |riak1|

    riak1.vm.network "public_network", bridge: 'vport1', ip:"192.168.233.101",  :netmask => "255.255.255.0"
    #riak1.vm.network "public_network", bridge: 'vport1', ip:"192.168.233.101", :netmask => "255.255.255.0", :adapter => 1
    #riak1.ssh.host = "192.168.233.101"

    riak1.vm.hostname = "riak1"
    riak1.vm.provider "virtualbox" do |vb|
      vb.name = "riak1"
      #vb.gui = true
      vb.customize [ "modifyvm", :id, "--cpus", "4" ]
      vb.customize ["modifyvm", :id, "--memory", 1024]
    end

    riak1.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "site.pp"
      puppet.options = "--verbose --debug"
    end

  end

  config.vm.define "riak2" do |riak2|
    riak2.vm.network "public_network", bridge: 'vport2', ip:"192.168.233.102", :auto_config => "false", :netmask => "255.255.255.0"

    riak2.vm.hostname = "riak2"
    riak2.vm.provider "virtualbox" do |vb|
      vb.name = "riak2"
      #vb.gui = true
      vb.customize [ "modifyvm", :id, "--cpus", "4" ]
      vb.customize ["modifyvm", :id, "--memory", 1024]
    end

    riak2.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "site.pp"
      puppet.options = "--verbose --debug"
    end
  end

  config.vm.define "riak3" do |riak3|
    #riak3.vm.network :public_network, :bridge => 'vport3', :use_dhcp_assigned_default_route => true
    riak3.vm.network "public_network", bridge: 'vport3', ip:"192.168.233.103", :auto_config => "false", :netmask => "255.255.255.0"

    riak3.vm.hostname = "riak3"
    riak3.vm.provider "virtualbox" do |vb|
      vb.name = "riak3"
      #vb.gui = true
      vb.customize [ "modifyvm", :id, "--cpus", "4" ]
      vb.customize ["modifyvm", :id, "--memory", 1024]
    end

    riak3.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "site.pp"
      puppet.options = "--verbose --debug"
    end
  end

end
