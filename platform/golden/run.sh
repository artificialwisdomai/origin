#!/bin/sh

SSH_PASSWORD=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
BUILD_TIME=$(date +%Y-%m-%d-%H-%M-%S)
PACKER_LOG=1 packer build -var ssh_password=${SSH_PASSWORD} -var build_time=${BUILD_TIME} bullseye.pkr.hcl
if [ $(echo $?) -eq 0 ]; then
	echo "Uploading image"
	bash upload-image.sh
	exit $?
else
	echo "System Errored"
        exit 1
fi
