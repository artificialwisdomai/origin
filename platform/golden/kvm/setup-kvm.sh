#!/bin/bash
#
# From https://github.com/goffinet/packer-kvm
#
# Set up KVM for debian or redhat
if [ -f /etc/debian_version ]; then
sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get -y install qemu-kvm libvirt-dev virtinst virt-viewer libguestfs-tools virt-manager uuid-runtime curl linux-source libosinfo-bin
virsh net-start default
virsh net-autostart default
elif [ -f /etc/redhat-release ]; then
yum -y install epel-release
yum -y upgrade
yum -y group install "Virtualization Host"
yum -y install virt-manager libvirt virt-install qemu-kvm xauth dejavu-lgc-sans-fonts virt-top libguestfs-tools virt-viewer virt-manager curl
ln -s /usr/libexec/qemu-kvm /usr/bin/qemu-system-x86_64
fi

# Install packer
#
yum -y install wget unzip || apt update && apt -y install wget unzip
latest=$(curl -L -s https://releases.hashicorp.com/packer | grep 'packer_' | sed 's/^.*<.*\">packer_\(.*\)<\/a>/\1/' | head -1)
wget https://releases.hashicorp.com/packer/${latest}/packer_${latest}_linux_amd64.zip
unzip packer*.zip
chmod +x packer
sudo mv packer /usr/local/bin/

