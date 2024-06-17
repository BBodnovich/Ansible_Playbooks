#!/bin/bash

# Verify user root is running this tool (required)
if [ "$(id -u)" -ne 0 ]; then
	echo 'This script must be run as root' >&2
	exit 1
fi

# Configure local repository to install ansible
mount /dev/sr0 /mnt

for i in AppStream BaseOS
do
	dnf config-manager --add-repo=file:///mnt/$i
	echo gpgcheck=0 >> /etc/yum.repos.d/mnt_$i.repo
done

dnf install -y ansible-core
umount /dev/sr0

for i in AppStream BaseOS; do rm -rf /etc/yum.repos.d/mnt/$i.repo; done

# Start Ansible Setup
ansible-galaxy collection install -r requirements.yml -p collections
sudo ansible-playbook -k -K main.yml
