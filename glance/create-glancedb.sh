#!/bin/bash
#Make sure you set the variable for the MySQL root password
MYSQL_ROOT_PW=Password1

#Create SQL file with SQL code to create DB
cat > create-glancedb.sql << END
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'Password1';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'Password1';
SHOW GRANTS FOR 'glance'@'%'
END

#Import SQL File
mysql -u root -p$MYSQL_ROOT_PW < create-glancedb.sql
