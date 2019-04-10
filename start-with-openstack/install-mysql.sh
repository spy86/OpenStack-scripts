#!/bin/bash

#Install MySQL and Python API
apt-get install -y mysql-server python-mysqldb

#Configure MySQL to Listen on all interfaces and use UTF-8
cat > /etc/mysql/conf.d/openstack.cnf << END
[mysqld]
bind-address = 0.0.0.0
default-storage-engine = innodb
innodb_file_per_table
collation-server = utf8_general_ci
init-connect = 'SET NAMES utf8'
character-set-server = utf8
END

#Restart MySQL Database Server
service mysql restart
