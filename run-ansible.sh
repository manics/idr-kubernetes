#!/bin/sh
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i inventory/ --become kubespray/cluster.yml kubespray/contrib/network-storage/glusterfs/glusterfs.yml "$@"
