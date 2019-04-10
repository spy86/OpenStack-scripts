#!/bin/bash
apt-get install -y glance python-glanceclient

cat > /etc/glance/glance-api.conf << END
[DEFAULT]
notification_driver = noop
verbose = True
[database]
connection = mysql://glance:Password1@controller/glance
backend = sqlalchemy
[glance_store]
default_store = file
filesystem_store_datadir = /var/lib/glance/images/
[image_format]
[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
project_name = service
username = glance
password = Password1
[matchmaker_redis]
[matchmaker_ring]
[oslo_concurrency]
[oslo_messaging_amqp]
[oslo_messaging_qpid]
[oslo_messaging_rabbit]
[oslo_policy]
[paste_deploy]
flavor = keystone
[store_type_location_strategy]
[task]
[taskflow_executor]
END

cat > /etc/glance/glance-registry.conf << END
[DEFAULT]
notification_driver = noop
verbose = True
[database]
connection = mysql://glance:Password1@controller/glance
backend = sqlalchemy
[glance_store]
[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
auth_plugin = password
project_domain_id = default
user_domain_id = default
project_name = service
username = glance
password = Password1
[matchmaker_redis]
[matchmaker_ring]
[oslo_messaging_amqp]
[oslo_messaging_qpid]
[oslo_messaging_rabbit]
[oslo_policy]
[paste_deploy]
flavor = keystone
END

su -s /bin/sh -c "glance-manage db_sync" glance
service glance-registry restart
service glance-api restart
rm -f /var/lib/glance/glance.sqlite
