#!/bin/bash

sudo rm -f $HOME/cloudinit-config.img
sudo mkdosfs -n CIDATA -C $HOME/cloudinit-config.img 8192
sudo chown -R $USER:$USER $HOME/cloudinit-config.img
mcopy -oi $HOME/cloudinit-config.img -s cloudinit-config/user-data ::
mcopy -oi $HOME/cloudinit-config.img -s cloudinit-config/meta-data ::

