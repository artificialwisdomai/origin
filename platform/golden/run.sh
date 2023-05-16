#!/bin/sh

# Set SSH password and build time
SSH_PASSWORD=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
BUILD_TIME=$(date +%Y-%m-%d-%H-%M-%S)
# Pass SSH password and build time to packer
PACKER_LOG=1 packer build -var ssh_password=${SSH_PASSWORD} -var build_time=${BUILD_TIME} bullseye.pkr.hcl
