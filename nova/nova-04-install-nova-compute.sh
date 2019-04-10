#!/bin/bash
apt-get install -y python-openstackclient
apt-get install -y nova-compute sysfsutils
openstack --version
