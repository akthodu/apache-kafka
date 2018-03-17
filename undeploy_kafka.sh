#!/bin/bash

CURR_PWD=$(pwd)
ANSIBLE_ROLES_PATH=$(dirname $CURR_PWD)
echo $ANSIBLE_ROLES_PATH
ansible-playbook kafka.yml --tags "uninstall"
