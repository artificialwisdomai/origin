#!/bin/sh

# If you need a password (e.g. for tty access) Set SSH password and build time
# SSH_PASSWORD=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
# echo $SSH_PASSWORD > .env
# SSH_CRYPTED_PASSWORD=$(openssl passwd -crypt "$SSH_PASSWORD")BUILD_TIME=$(date +%Y-%m-%d-%H-%M-%S)
# Change the followin:
# PACKER_LOG=1 packer build -var ssh_password=${SSH_CRYPTED_PASSWORD} bullseye.pkr.hcl

PACKER_LOG=1 packer build bullseye.pkr.hcl
