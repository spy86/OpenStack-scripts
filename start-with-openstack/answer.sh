##############################
#                           ##
# @author: Maciej Michalski ##
#                           ##
##############################
#!/bin/bash
#Make sure that you set the correct answer file that you need to edit
ANSWER_FILE='/root/answers.txt'

#In the demo the interface on the system is eth0. Check the name of your interface
#and set the variable here:
INTERFACE=eth0

#Make sure you set your own NTP Server or leave the following variable blank
#NTP_SERVER=
NTP_SERVER='192.168.0.3'

sed -i "s/^\(CONFIG_NTP_SERVERS\s*=\s*\).*\$/\1$NTP_SERVER/" $ANSWER_FILE
sed -i "s/^\(CONFIG_DEFAULT_PASSWORD\s*=\s*\).*\$/\1Password1/" $ANSWER_FILE
sed -i "s/^\(CONFIG_KEYSTONE_ADMIN_PW\s*=\s*\).*\$/\1Password1/" $ANSWER_FILE
sed -i "s/^\(CONFIG_KEYSTONE_DEMO_PW\s*=\s*\).*\$/\1Password1/" $ANSWER_FILE
sed -i "s/^\(CONFIG_CINDER_VOLUMES_SIZE\s*=\s*\).*\$/\14G/" $ANSWER_FILE
sed -i "s/^\(CONFIG_NOVA_COMPUTE_PRIVIF\s*=\s*\).*\$/\1lo/" $ANSWER_FILE
sed -i "s/^\(CONFIG_NOVA_NETWORK_PRIVIF\s*=\s*\).*\$/\1lo/" $ANSWER_FILE
sed -i "s/^\(CONFIG_NEUTRON_OVS_BRIDGE_MAPPINGS\s*=\s*\).*\$/\1physnet1:br-ex/" $ANSWER_FILE
sed -i "s/^\(CONFIG_NOVA_NETWORK_PUBIF\s*=\s*\).*\$/\1$INTERFACE/" $ANSWER_FILE
sed -i "s/^\(CONFIG_NEUTRON_OVS_BRIDGE_IFACES\s*=\s*\).*\$/\1br-ex:$INTERFACE/" $ANSWER_FILE
sed -i "s/^\(CONFIG_USE_EPEL\s*=\s*\).*\$/\1y/" $ANSWER_FILE
grep ^CONFIG_NTP_SERVERS $ANSWER_FILE
grep ^CONFIG_DEFAULT_PASSWORD $ANSWER_FILE
grep ^CONFIG_KEYSTONE_ADMIN_PW $ANSWER_FILE
grep ^CONFIG_KEYSTONE_DEMO_PW $ANSWER_FILE
grep ^CONFIG_CINDER_VOLUMES_SIZE $ANSWER_FILE
grep ^CONFIG_NOVA_COMPUTE_PRIVIF $ANSWER_FILE
grep ^CONFIG_NOVA_NETWORK_PRIVIF $ANSWER_FILE
grep ^CONFIG_NEUTRON_OVS_BRIDGE_MAPPINGS $ANSWER_FILE
grep ^CONFIG_USE_EPEL $ANSWER_FILE
grep ^CONFIG_NOVA_NETWORK_PUBIF $ANSWER_FILE
grep ^CONFIG_NEUTRON_OVS_BRIDGE_IFACES $ANSWER_FILE
