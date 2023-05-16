#!/bin/sh

# Check for or create 'debian-golden' bucket in OCI
if [ $(oci os bucket list | jq '.data[0].name' | grep "debian-golden" | wc -l) -ge 1 ] ; then
  echo "bucket debian-golden exists"
else
  oci os bucket create --name debian-golden
  if [ $? -gt 0 ]; then exit 1; fi
fi

# Check for and upload golden.raw disk image to 'debian-golden' bucket in OCI
if [ -f build/golden.raw-disk001.vmdk ]; then
  oci os object put --bucket-name debian-golden --file build/golden.raw-disk001.vmdk --name golden.raw-disk001.vmdk --force
  if [ $? -gt 0 ]; then exit 1; fi
else
  echo no vmdk to upload!
  exit 1
fi

# Set up and track the import of the image into OCI
NAMESPACE=$(oci os ns get | jq .data | tr -d '"')
WORK_REQUEST=$(oci compute image import from-object --namespace $NAMESPACE \
	--launch-mode PARAVIRTUALIZED --display-name debian-golden \
	--bucket-name debian-golden --name golden.raw-disk001.vmdk )
WORK_REQUEST_ID=$(echo $WORK_REQUEST | jq '."opc-work-request-id"' | tr -d '"')
WORK_DISPLAY_NAME=$(echo $WORK_REQUEST | jq '.data."display-name"' | tr -d '"')

# check Work Request every 60s until the status is no longer "IN_PROGRESS"
echo Start time: $(date)
while [ "$(oci work-requests work-request get --work-request-id $WORK_REQUEST_ID | jq '.data.status' | tr -d '"')" == "IN_PROGRESS" ]; do echo waiting 1m; sleep 60; done
echo "SUCCESS importing $WORK_DISPLAY_NAME"
