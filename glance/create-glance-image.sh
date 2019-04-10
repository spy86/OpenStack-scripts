#!/bin/bash
source /root/adminrc.sh
wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
openstack  image create  \
 --file cirros-0.3.4-x86_64-disk.img --public  \
 --disk-format qcow2 --container-format bare \
  cirros

