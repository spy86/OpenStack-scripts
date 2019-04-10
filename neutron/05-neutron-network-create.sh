#!/bin/bash
source /root/adminrc.sh
neutron net-create provider --shared \
--provider:physical_network provider \
--provider:network_type flat
neutron subnet-create provider 10.10.10.0/24   \
  --name provider-subnet --gateway 10.10.10.1
neutron net-list
