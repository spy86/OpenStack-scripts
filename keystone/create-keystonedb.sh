#!/bin/bash
#Make sure you set the variable for the MySQL root password
MYSQL_ROOT_PW=Password1

#Create SQL file with SQL code to create DB
cat > create-keystonedb.sql << END
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'Password1';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'Password1';
SHOW GRANTS FOR 'keystone'@'%'
END

#Import SQL File
mysql -u root -p$MYSQL_ROOT_PW < create-keystonedb.sql
