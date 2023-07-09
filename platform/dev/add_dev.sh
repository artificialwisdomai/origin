#!/bin/bash

sudo mkdir /models
sudo mkfs.xfs /dev/nvme0n1
echo '/dev/nvme0n1  /models xfs defaults  0  2' | sudo tee -a /etc/fstab
sudo mount -a
sudo chmod 777 /models

mkdir /models/cache
mv ~/.cache ~/.cache.orig
ln -s /models/cache ~/.cache
mkdir /models/dev
ln -s /models/dev


