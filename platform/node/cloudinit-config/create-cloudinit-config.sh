#!/bin/bash

sudo rm -f $HOME/cloudinit-config-${1}.img
sudo mkdosfs -n CIDATA -C $HOME/cloudinit-config-${1}.img 8192
sudo chown -R $USER:$USER $HOME/cloudinit-config-${1}.img
mcopy -oi $HOME/cloudinit-config-${1}.img -s ${1}/user-data ::
mcopy -oi $HOME/cloudinit-config-${1}.img -s ${1}/meta-data ::

