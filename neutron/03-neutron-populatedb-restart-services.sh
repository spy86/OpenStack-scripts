#!/bin/bash
#Run on the controller node after neutron is installed
cat > /etc/neutron/neutron.conf << END
[DEFAULT]
core_plugin = ml2
service_plugins =
auth_strategy = keystone
rpc_backend = rabbit
notify_nova_on_port_status_changes = True
notify_nova_on_port_data_changes = True
[agent]
root_helper = sudo /usr/bin/neutron-rootwrap /etc/neutron/rootwrap.conf
[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_plugin = password
project_domain_id = default
user_domain_id = default
project_name = service
username = neutron
password = Password1
[database]
connection = mysql://neutron:Password1@controller/neutron
[nova]
auth_url = http://controller:35357
auth_type = password
project_domain_id = default
user_domain_id = default
region_name = RegionOne
project_name = service
username = nova
password = Password1
[oslo_concurrency]
lock_path = $state_path/lock
[oslo_messaging_rabbit]
rabbit_host = controller
rabbit_userid = openstack
rabbit_password = Password1
END

cat > /etc/neutron/plugins/ml2/ml2_conf.ini << END
[ml2]
type_drivers = flat,vlan
tenant_network_types =
mechanism_drivers = linuxbridge
extension_drivers = port_security
[ml2_type_flat]
flat_networks = provider
[ml2_type_vlan]
[ml2_type_gre]
[ml2_type_vxlan]
[ml2_type_geneve]
[securitygroup]
enable_ipset = True
END

cat > /etc/neutron/plugins/ml2/linuxbridge_agent.ini << END
[linux_bridge]
physical_interface_mappings = provider:eth0

[vxlan]
enable_vxlan = False

[agent]

[securitygroup]
enable_security_group = True
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
END

cat > /etc/neutron/dhcp_agent.ini << END
[DEFAULT]
interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = True
[AGENT]e_agent
END

cat > /etc/neutron/metadata_agent.ini << END
[DEFAULT]
nova_metadata_ip = controller
metadata_proxy_shared_secret = Password1
[AGENT]
END

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
vif_plugging_timeout=10
vif_plugging_is_fatal=False
[neutron]
url = http://controller:9696
auth_url = http://controller:35357
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = neutron
password = Password1
service_metadata_proxy = True
metadata_proxy_shared_secret = Password1
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
vncserver_listen = 
vncserver_proxyclient_address = 
[glance]
host = controller
[oslo_concurrency]
lock_path = /var/lib/nova/tmp
END

#Sync DB
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

#Restart Services
service nova-api restart
service neutron-server restart
service neutron-plugin-linuxbridge-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart

rm -f /var/lib/neutron/neutron.sqlite
