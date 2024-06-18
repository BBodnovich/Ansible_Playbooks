# Verify user root is running this tool (required)
if [ "$(id -u)" -ne 0 ]; then
	echo 'This script must be run as root' >&2
	exit 1
fi


# Enable RHEL repos to pull required base packages
subscription-manager register;
subscription-manager attach;
subscription-manager repos --enable $(subscription-manager repos --list | grep 'ansible-automation-platform' | grep 'aarch64-rpms' | awk '{ print $3 }');
dnf install -y git tmux ansible-core ansible-navigator;
subscription-manager unregister;


# Return git clone
echo "git clone https://github.com/BBodnovich/Homelab_Playbooks.git"
