node basenode {

  exec { "apt_get_update":
    command => "/usr/bin/apt-get -y update"
  }

  Exec["apt_get_update"] -> Package <| |>

  exec { "download_riak":
#    command => "/usr/bin/wget 192.168.233.216/riak_2.0.5-1_amd64.deb -O /tmp/riak_2.0.5-1_amd64.deb",
    command => "/usr/bin/wget http://s3.amazonaws.com/downloads.basho.com/riak/2.0/2.0.5/ubuntu/trusty/riak_2.0.5-1_amd64.deb -O /tmp/riak_2.0.5-1_amd64.deb",
    cwd     => "/tmp",
    creates => "/tmp/riak_2.0.5-1_amd64.deb",
  }

  exec { "download_riakcs":
#    command => "/usr/bin/wget 192.168.233.216/riak-cs_2.0.0-1_amd64.deb -O /tmp/riak-cs_2.0.0-1_amd64.deb",
    command => "/usr/bin/wget http://s3.amazonaws.com/downloads.basho.com/riak-cs/2.0/2.0.0/ubuntu/trusty/riak-cs_2.0.0-1_amd64.deb -O /tmp/riak-cs_2.0.0-1_amd64.deb",
    cwd     => "/tmp",
    creates => "/tmp/riak-cs_2.0.0-1_amd64.deb",
  }

  package { "install_riak":
    name     =>  "riak",
    ensure   =>  installed,
    provider =>  dpkg,
    source   =>  "/tmp/riak_2.0.5-1_amd64.deb",
    require  => [
                   Exec["download_riak"],
                ]
  }


  package { "install_riakcs":
    name     =>  "riak-cs",
    ensure   =>  installed,
    provider =>  dpkg,
    source   =>  "/tmp/riak-cs_2.0.0-1_amd64.deb",
    require  => [
                   Exec["download_riakcs"],
                   Package["riak"],
                ]
  }

  file { "limits_conf_riak":
    ensure => file, 
    owner => root,
    group => root,
    mode => 0644,
    path => '/etc/security/limits.d/riakcs.conf',
    source => "/vagrant/files/limits_riakcs.conf"
  }

}

node riakfirst inherits basenode {

  exec { "download_stanchion":
#    command => "/usr/bin/wget 192.168.233.216/stanchion_2.0.0-1_amd64.deb -O /tmp/stanchion_2.0.0-1_amd64.deb",
    command => "/usr/bin/wget http://s3.amazonaws.com/downloads.basho.com/stanchion/2.0/2.0.0/ubuntu/trusty/stanchion_2.0.0-1_amd64.deb -O /tmp/stanchion_2.0.0-1_amd64.deb",
    cwd     => "/tmp",
    creates => "/tmp/stanchion_2.0.0-1_amd64.deb",
  }

  package { "install_stanchion":
    name     =>  "stanchion",
    ensure   =>  installed,
    provider =>  dpkg,
    source   =>  "/tmp/stanchion_2.0.0-1_amd64.deb",
    require  => [
                   Exec["download_stanchion"],
                   Package["riak-cs"],
                ]
  }

  file { "riak_conf":
    ensure => file,
    owner => riakcs,
    group => riak,
    mode => 0644,
    path => '/etc/riak/riak.conf',
    source => "/vagrant/files/r1-riak.conf",
    require  => [
                   Package["riak"],
                ]
  }

  file { "riak_app_conf":
    ensure => file,
    owner => riak,
    group => riak,
    mode => 0644,
    path => '/etc/riak/app.config',
    source => "/vagrant/files/r1-app.config",
    require  => [
                   Package["riak"],
                ]
  }

  file { "riak_cs_conf":
    ensure => file,
    owner => riakcs,
    group => riak,
    mode => 0644,
    path => '/etc/riak-cs/riak-cs.conf',
    source => "/vagrant/files/r1-riak-cs.conf",
    require  => [
                   Package["riak-cs"],
                ]
  }

  file { "stanchion_conf":
    ensure => file,
    owner => stanchion,
    group => riak,
    mode => 0644,
    path => '/etc/stanchion/stanchion.conf',
    source => "/vagrant/files/stanchion.conf",
    require  => [
                   Package["stanchion"],
                ]
  }

#  service { "stanchion":
#    ensure => running,
#    enable => true,
#    require  => [
#                   Package["stanchion"],
#                   File["/etc/stanchion/stanchion.conf"],
#                ]
#  }
#
#  service { "riak-cs":
#    ensure => running,
#    enable => true,
#    require  => [
#                   Package["riak-cs"],
#                   File["/etc/riak-cs/riak-cs.conf"],
#                   Service["stanchion"],
#                ]
#  }

}

node basehost {

  exec { "apt_get_update":
    command => "/usr/bin/apt-get -y update"
  }

  Exec["apt_get_update"] -> Package <| |>

  $host_packages = [
                      "git",
                      "openvswitch-switch",
                      "virtualbox",
                      "vagrant",
                      "vim",
                    ]

  package { $host_packages:
    ensure => installed,
  }

  exec { "network_setup":
    user => "root",
    path => "/usr/bin:/usr/sbin:/bin",
    command => "/bin/bash /root/proj/scripts/setup_host_net.sh",
    require => [
                  Package["openvswitch-switch"],
               ],
  }


  exec { "vagrant_providers":
    user => "root",
    path => "/usr/bin:/usr/sbin:/bin",
    environment => "HOME=/root",
    command => "/usr/bin/vagrant plugin install vagrant-vbguest",
    require => [
                  Package["vagrant"],
               ],
  }
}

import 'nodes/*.pp'
