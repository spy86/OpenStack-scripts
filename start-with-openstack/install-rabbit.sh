#!/bin/bash

#Install Message Queue Server
apt-get install -y rabbitmq-server

#Configure a User Account in Rabbit: user = openstack password = Password1
rabbitmqctl add_user openstack Password1

#Here we allow permissions for the user to configuration, write and read access
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

#List Users
rabbitmqctl list_users

#List Permissions for openstack user
rabbitmqctl list_user_permissions openstack
