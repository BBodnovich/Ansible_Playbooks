#!/bin/bash
# Set up ansible core requirements offline with no internet connection
# Utilizes installation .iso to create a local repository for offline use


# Verify user root is running this tool
if [ "$(id -u)" -ne 0 ]; then
	echo 'This script must be run as root' >&2
	exit 1
fi


# Create local repository from installation .iso
mkdir /localrepo

if ! mount /dev/sr0 /mnt; do
	echo "Failed to mount /dev/sr0 to /mnt"
	exit 1;
done

for repo in AppStream BaseOS; do
	cp -r /mnt/$repo /localrepo
    dnf config-manager --add-repo="file:///localrepo/$repo"
done

cp /mnt/RPM-GPG-KEY-redhat-release /localrepo
rpm --import /mnt/RPM-GPG-KEY-redhat-release
umount /dev/sr0


# Install Base packages
if ! dnf install -y ansible-core tmux; then
    echo 'Failed to install required packages' >&2
    exit 1
fi

exit 0
