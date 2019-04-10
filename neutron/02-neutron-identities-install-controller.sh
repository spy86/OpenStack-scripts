#!/bin/bash
#This should run on Controller Node
#Probably a good idea to update metadata before any install
apt-get update 

#Create Identities
source /root/adminrc.sh
openstack user create --domain default --password-prompt neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696

#Install on Controller
apt-get install -y \
  neutron-server \
  neutron-plugin-ml2 \
  neutron-plugin-linuxbridge-agent \
  neutron-dhcp-agent \
  neutron-metadata-agent \
  python-neutronclient \
  conntrack
