###
#
# Definition of virtual environment: Two A30s
#
# DO NOT RUN AS ROOT.
#
# This workflow is designed to be run as a non-root user. For each
# Virtual machine, there should be a different user. E.G. in beast-08
# there are three A30s. With 3 virtual machines, there should be three
# users. aw1, aw2, aw3. Each user will receive a different permission
# context. The goal is to NOT NEED sudo within this script.
#
# TODO(sdake): passwordless sudo required.


###
#
# The choices are:
#
# One A30 -> 0000:24:00.0
# Two A30 -> 0000:01:00.0, 0000:41:00.0
# Two A40 -> 0000:61:00.0, 0000:a1:00.0


###
#
# Variables:
#
# host_net -> host network interface.
# id -> PCI bus device number.
#
# id must be a two character hex number. id must be unique per host.
# The consumption of id fails to disambiguate # parent pci bridges.

host_net="enp193s0f0"
id="01"



###
#
# Environment initialization

sudo -E install -d -m 0755 -o "${USER}" -g "${USER}" "/var/run/artificial_wisdom/${id}/"

###
#
# Locals
# ${repos_sock}.pid is created by virtiofsd. You need the name to clean up.
# TODO(sdake): The ${mac} variable may collide with mulitple systems.
# FATAL(sdake): ${mac}!

mac="c2:67:4f:53:29:${id}"
kernel_img="/var/lib/artificial_wisdom/hypervisor-fw"
config_img="/var/lib/artificial_wisdom/cloudinit-config-wise-a30x2.img"
disk_img="/var/lib/artificial_wisdom/${id}/baseline.img"
virtiofs_sock="/var/run/artificial_wisdom/${id}/virtiofs.sock"
api_sock="/var/run/artificial_wisdom/${id}/api.sock"
vsock="/var/run/artificial_wisdom/${id}/vsock.sock"
log="/var/run/artificial_wisdom/${id}/log.txt"

repos_sock_pid="${repos_sock}.pid"

###
#
# clean prior run
#
# TODO(sdake): Incoherent logic

rm -f "${repos_sock}"
rm -f "${models_sock}"
rm -f "${api_sock}"
rm -f "${vsock}"
rm -f "${log}"
rm -f "${repos_sock_pid}"


###
#
# TODO(sdake): Bake this into the baseline image
#
# Ensure your user is a member of the kvm group so that
# you can read/write the /dev/kvm device.
#
# sudo usermod -a -G kvm yourusername


###
#
# The /dev/vfio directory and files must be RW for this user
# There is a way to do this.
# 
# man driverctl
#
# TODO(sdake): for a different, and possibily better approach, see:
# https://www.reddit.com/r/VFIO/comments/f7py35/nonroot_pcie_passthrough/

sudo chown root:kvm /dev/vfio
sudo chmod 666 /dev/vfio/vfio
ls /dev/vfio | grep -v "vfio"  | xargs -I {} sudo chown sdake:sdake /dev/vfio/{}


###
#
# A network device needs to be setup to be used by the virtual
# machine. There are many ways to do this. Here is a different
# Example:
#
# https://github.com/kdwinter/vfio-setup/blob/master/windows7vm.sh#L119-L135


###
#
# Depending on swtch design, this device may not be hairpinned.
# As a result, you may not be able to SSH into the virtual macine
# locally from the host. Instead use ssh with your local client (ie. MacOS).

sudo ip link delete link "${host_net}" name macvtap${id}


###
#
# Create a macvtap on the host network

sudo ip link add link "${host_net}" name macvtap${id} type macvtap
sudo ip link set macvtap${id} address "${mac}" up
sudo ip link show macvtap${id}


###
#
# A new character device is created for this interface
# N.B. I am fairly sure there is a more appropraite way
# to do this with system tools.

tapindex=$(< /sys/class/net/macvtap${id}/ifindex)
tapdevice="/dev/tap$tapindex"


###
#
# Ensure that we can access this device

sudo chown "$UID:$UID" "$tapdevice"

###
#
# wise-mounts builds the mount directory at
#
# /run/artificial_wisdom/${id}-mounts/
#
# contains submounts dataset, models, cache, home, repos

/usr/local/bin/virtiofsd-latest \
    --sandbox=none \
    --announce-submounts \
    --shared-dir=/run/artificial_wisdom/01-mounts/ \
    --socket-path="${virtiofs_sock}" \
    --cache=never \
    --thread-pool-size=4 &

# https://gitlab.com/virtio-fs/virtiofsd/-/blob/main/doc/xattr-mapping.md
#
# --xattr
# --posix-acl
# --killpriv-v2
# --allow-direct-io
# --writeback
# --sandbox=namespace


###
#
# Wait a few seconds for virtiofsd to start
# TODO(sdake): Wrong in all the wrong ways.

sleep 2

###
#
# Start the hypervisor

/usr/local/bin/cloud-hypervisor \
	--api-socket "${api_sock}" \
	--kernel "${kernel_img}" \
	--disk path="${disk_img},direct=on" \
        --disk path="${config_img},readonly=on,direct=on" \
	--serial tty \
	--console pty \
	--cpus "boot=32" \
        --net fd=3,mac=${mac} 3<>$"${tapdevice}" \
	-v \
	--vsock cid=3,socket="${vsock}" \
	--log-file "${log}" \
        --cmdline "rd.module_blacklist=nouveau,nvidiafb console=tty0 root=/dev/vda1 rw" \
	--fs tag="homefs,socket=${virtiofs_sock},num_queues=1,queue_size=512" \
        --memory "size=256G,hugepages=on,hugepage_size=2M" \
        --device path="/sys/bus/pci/devices/0000:01:00.0" \
        --device path="/sys/bus/pci/devices/0000:41:00.0"


###
#
# Delete the host network

sudo ip link delete link "$host_net" name macvtap${id}


###
#
# Stop virtiofsd

# TODO(sdake): sort out the wamense


###
#
# TODO(sdake): This may be an approach to provide networking via
# vhost-user-net backend. I am not sure this works.
#
# vhost_user_net --net-backend ip=192.168.33.63,mask=255.255.255.0,socket="${artificial_wisdom_net_sock}",client=on,num_queues=2,queue_size=1024
