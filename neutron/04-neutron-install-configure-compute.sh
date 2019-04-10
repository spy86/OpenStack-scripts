#!/bin/bash
##To be run on the compute node

apt-get update
apt-get install -y neutron-plugin-linuxbridge-agent conntrack

cat > /etc/neutron/neutron.conf << END
[DEFAULT]
core_plugin = ml2
rpc_backend = rabbit
auth_strategy = keystone

[matchmaker_redis]
[matchmaker_ring]
[quotas]
[agent]
root_helper = sudo /usr/bin/neutron-rootwrap /etc/neutron/rootwrap.conf
[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
project_name = service
username = neutron
password = Password1

[database]
[nova]
[oslo_concurrency]
lock_path = $state_path/lock
[oslo_policy]
[oslo_messaging_amqp]
[oslo_messaging_qpid]
[oslo_messaging_rabbit]
rabbit_host = controller
rabbit_userid = openstack
rabbit_password = Password1

[qos]
END
cat > /etc/neutron/plugins/ml2/linuxbridge_agent.ini << END
[linux_bridge]
physical_interface_mappings = provider:eth0
[vxlan]
enable_vxlan = False
[agent]
prevent_arp_spoofing = True
[securitygroup]
enable_security_group = True
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
END

cat > /etc/nova/nova.conf << END
[DEFAULT]
rpc_backend = rabbit
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
enabled_apis=ec2,osapi_compute,metadata
auth_strategy = keystone
my_ip = 192.168.56.102
network_api_class = nova.network.neutronv2.api.API
security_group_api = neutron
linuxnet_interface_driver = nova.network.linux_net.NeutronLinuxBridgeInterfaceDriver
firewall_driver = nova.virt.firewall.NoopFirewallDriver
vif_plugging_timeout=10
vif_plugging_is_fatal=False

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

[neutron]
url = http://controller:9696
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
region_name = RegionOne
project_name = service
username = neutron
password = Password1

END

service nova-compute restart
service neutron-plugin-linuxbridge-agent restart

