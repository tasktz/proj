#!/bin/bash

#By: Tomasz Zaleski <tzaleski@gmail.com>
#Date: 2015-04-09 23:00
#Ver: 0.1

/usr/bin/ovs-vsctl add-br rbridge
/sbin/ifconfig rbridge up
/usr/bin/ovs-vsctl add-port rbridge eth0
/sbin/ifconfig eth0 0
/sbin/ifconfig rbridge 192.168.233.100 netmask 255.255.255.0
/sbin/route add default gw 192.168.233.2
/sbin/ip tuntap add mode tap vport1
/sbin/ip tuntap add mode tap vport2
/sbin/ip tuntap add mode tap vport3
/sbin/ifconfig vport1 up
/sbin/ifconfig vport2 up
/sbin/ifconfig vport3 up
/usr/bin/ovs-vsctl add-port rbridge vport1
/usr/bin/ovs-vsctl add-port rbridge vport2
/usr/bin/ovs-vsctl add-port rbridge vport3
