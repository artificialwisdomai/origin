#!/bin/sh

SSH_PASSWORD=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
PACKER_LOG=1 packer -var ssh_password=${SSH_PASSWORD} build bullseye.pkr.hcl
