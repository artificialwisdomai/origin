#!/bin/sh

mkdir -p ${PWD}/packer_logs
# This SSH password remains insecure, however, its more secure then it was.
# SSH_PASSWORD=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
# pass an additional flag `-var ssh_password=${SSH_PASSWORD} to use.
# to simplify development this is disabled at the moment.

PACKER_LOG_PATH=${PWD}/packer_logs/log.txt PACKER_LOG=1 packer build -force -on-error=abort bullseye.pkr.hcl
