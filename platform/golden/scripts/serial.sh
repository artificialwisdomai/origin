#!/bin/sh

cat > /tmp/fixes.sh <<EOF
#!/bin/bash
set -x
echo 'GRUB_CMDLINE_LINUX="console=ttyS0"' >> /etc/default/grub
update-grub

if [ -f /etc/udev/rules.d/70-persistent-net.rules ] ; then 
  rm /etc/udev/rules.d/70-persistent-net.rules
  ln -s /dev/null /etc/udev/rules.d/70-persistent-net.rules
fi

echo 'packer ALL=(ALL) NOPASSWD:ALL'>> /etc/sudoers.d/91-packer

passwd -d packer

mkdir /home/packer/.ssh
chmod 700 /home/packer/.ssh
curl -sLo - https://github.com/sdake.keys >> /home/packer/.ssh/authorized_keys
curl -sLo - https://github.com/rstarmer.keys >> /home/packer/.ssh/authorized_keys
EOF

echo ${SSH_PASSWORD} | sudo -S bash /tmp/fixes.sh