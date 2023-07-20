#!/bin/bash

rm -f $HOME/cloudinit-config-${1}.img
/usr/sbin/mkdosfs -n CIDATA -C $HOME/cloudinit-config-${1}.img 8192
mcopy -oi $HOME/cloudinit-config-${1}.img -s ${1}/user-data ::
mcopy -oi $HOME/cloudinit-config-${1}.img -s ${1}/meta-data ::
sudo cp $HOME/cloudinit-config-${1}.img /var/lib/artificial_wisdom/
