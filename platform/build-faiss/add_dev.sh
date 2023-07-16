#!/bin/bash

sudo apt-get update && sudo apt-get dist-upgrade -y

# mount nvme disk on /models
sudo mkdir /models
sudo mkfs.xfs /dev/nvme0n1
echo '/dev/nvme0n1  /models xfs defaults  0  2' | sudo tee -a /etc/fstab
sudo mount -a
sudo chmod 777 /models

# Add pointers to large data dirs into the 'ubuntu' user $HOME
mkdir /models/cache
mv ~/.cache ~/.cache.orig
ln -s /models/cache ~/.cache
mkdir /models/dev
ln -s /models/dev
mkdir /models/local
ln -s /models/local ~/.local

echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
