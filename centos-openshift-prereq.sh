#!/bin/sh
# https://docs.openshift.org/latest/install_config/install/host_preparation.html

set -eu

echo $(hostname -i) $(hostname -f) >> /etc/hosts

yum install -y docker

#/usr/share/container-storage-setup/container-storage-setup
cat << EOF > /etc/sysconfig/docker-storage-setup
# Overrides /usr/share/container-storage-setup/container-storage-setup
CONTAINER_THINPOOL=container-thinpool
VG=docker
DEVS=/dev/vdb
EOF

docker-storage-setup
systemctl start docker
systemctl enable docker

# ansible-playbook -i openshift-inventory.yml openshift-ansible/playbooks/byo/openshift-node/network_manager.yml
# ansible-playbook -i openshift-inventory.yml openshift-ansible/playbooks/byo/config.yml
