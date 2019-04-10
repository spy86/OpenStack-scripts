#!/bin/bash
#Make sure you set the variable for the MySQL root password
MYSQL_ROOT_PW=Password1

#Create SQL file with SQL code to create DB
cat > create-neutrondb.sql << END
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'Password1';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'Password1';
SHOW GRANTS FOR 'neutron'@'%'
END

#Import SQL File
mysql -u root -p$MYSQL_ROOT_PW < create-neutrondb.sql
