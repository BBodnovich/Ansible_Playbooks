#!/bin/bash
# Set up ansible ansible core requirements with online connection
# Register system with RedHat and enable Ansible Automation Platform repositories


# Verify user root is running this tool
if [ "$(id -u)" -ne 0 ]; then
	echo 'This script must be run as root' >&2
	exit 1
fi


# Gather necessary credentials
read -p 'Local Password:  ' -s local_password && printf '\n'
read -p 'RedHat Username: ' rhel_username
read -p 'RedHat Password: ' -s rhel_password && printf '\n'


# Register with Red Hat
if ! subscription-manager register --username "$rhel_username" --password "$rhel_password"; then
    echo 'Failed to register with Red Hat' >&2
    exit 1
fi


# Attach subscription
if ! subscription-manager attach; then
    echo 'Failed to attach subscription' >&2
    exit 1
fi


# Enable Ansible Automation Platform Repositories
rhel_ansible_repo=$(subscription-manager repos --list | awk -F ': ' '/ansible.*64-rpms/ { print $2 }')

if [ -z "$rhel_ansible_repo" ]; then
    echo 'Failed to find the Ansible Automation Platform repository' >&2
    exit 1
fi

if ! subscription-manager repos --enable "$rhel_ansible_repo"; then
    echo 'Failed to enable the Ansible Automation Platform repository' >&2
    exit 1
fi


# Install Base packages
if ! dnf install -y ansible-core ansible-navigator git tmux; then
    echo 'Failed to install required packages' >&2
    exit 1
fi

exit 0
