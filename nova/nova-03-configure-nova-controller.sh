#!/bin/bash
##Run this on the Controller Node
cat > /etc/nova/nova.conf << END
[DEFAULT]
my_ip = 192.168.56.6
dhcpbridge_flagfile=/etc/nova/nova.conf
dhcpbridge=/usr/bin/nova-dhcpbridge
logdir=/var/log/nova
state_path=/var/lib/nova
lock_path=/var/lock/nova
force_dhcp_release=True
libvirt_use_virtio_for_bridges=True
verbose=True
rpc_backend = rabbit
auth_strategy = keystone
ec2_private_dns_show_ip=True
api_paste_config=/etc/nova/api-paste.ini
enabled_apis=osapi_compute,metadata
network_api_class = nova.network.neutronv2.api.API
security_group_api = neutron
linuxnet_interface_driver = nova.network.linux_net.NeutronLinuxBridgeInterfaceDriver
firewall_driver = nova.virt.firewall.NoopFirewallDriver
[database]
connection = mysql://nova:Password1@controller/nova
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
vncserver_listen = $my_ip
vncserver_proxyclient_address = $my_ip
[glance]
host = controller
[oslo_concurrency]
lock_path = /var/lib/nova/tmp
END

#Sync Database
su -s /bin/sh -c "nova-manage db sync" nova

#Restart Services
service nova-api restart
service nova-cert restart
service nova-consoleauth restart
service nova-scheduler restart
service nova-conductor restart
service nova-novncproxy restart

#Remove DB
rm -f /var/lib/nova/nova.sqlite
