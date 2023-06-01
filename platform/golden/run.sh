#!/bin/sh

# Set SSH password
SSH_PASSWORD=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Pass SSH password and build time to packer
PACKER_LOG=${PACKER_LOG:-0}
PACKER_LOG=$PACKER_LOG packer build -var ssh_password=${SSH_PASSWORD} bullseye.pkr.hcl
