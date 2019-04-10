#!/bin/bash
##Run on Compute node

#Nova.conf check my_ip
cat > /etc/nova/nova.conf << END
[DEFAULT]
my_ip = 192.168.56.7
dhcpbridge_flagfile=/etc/nova/nova.conf
dhcpbridge=/usr/bin/nova-dhcpbridge
logdir=/var/log/nova
state_path=/var/lib/nova
lock_path=/var/lock/nova
force_dhcp_release=True
libvirt_use_virtio_for_bridges=True
verbose=True
ec2_private_dns_show_ip=True
api_paste_config=/etc/nova/api-paste.ini
enabled_apis=osapi_compute,metadata
rpc_backend = rabbit
auth_strategy = keystone
network_api_class = nova.network.neutronv2.api.API
security_group_api = neutron
linuxnet_interface_driver = nova.network.linux_net.NeutronLinuxBridgeInterfaceDriver
firewall_driver = nova.virt.firewall.NoopFirewallDriver
[oslo_messaging_rabbit]
rabbit_host = controller
rabbit_userid = openstack
rabbit_password = Password1
[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
project_name = service
username = nova
password = Password1
[vnc]
enabled = True
vncserver_listen = 0.0.0.0
vncserver_proxyclient_address = $my_ip
novncproxy_base_url = http://controller:6080/vnc_auto.html
[glance]
host = controller
[oslo_concurrency]
lock_path = /var/lib/nova/tmp
END

## check for KVM support
KVM=$( grep -Ec '(vmx|svm)' /proc/cpuinfo )
if (( $KVM < 1 )); then
  echo "Setting QEMU Support"
  sed -i "s/^virt_type\s*=\s*kvm/virt_type=qemu/" /etc/nova/nova-compute.conf
else
  echo "You have KVM Support"
fi

#Restart Nova
service nova-compute restart

#Remove DB
rm -f /var/lib/nova/nova.sqlite
