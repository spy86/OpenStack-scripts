#!/bin/bash
#Make sure you set the variable for the MySQL root password
MYSQL_ROOT_PW=Password1

#Create SQL file with SQL code to create DB
cat > create-novadb.sql << END
CREATE DATABASE nova;
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'Password1';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'Password1';
SHOW GRANTS FOR 'nova'@'%'
END

#Import SQL File
mysql -u root -p$MYSQL_ROOT_PW < create-novadb.sql
