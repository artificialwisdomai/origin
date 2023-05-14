if [ $(oci os bucket list | jq '.data[0].name' | grep "debian-golden" | wc -l) -ge 1 ] ; then
  echo "bucket debian-golden exists"
else
  oci os bucket create --name debian-golden
  if [ $? -gt 0 ]; then exit 1; fi
fi
if [ -f build/golden.raw-disk001.vmdk ]; then
  oci os object put --bucket-name debian-golden --file build/golden.raw-disk001.vmdk --name golden.raw-disk001.vmdk --force
  if [ $? -gt 0 ]; then exit 1; fi
else
  echo no vmdk to upload!
  exit 1
fi
NAMESPACE=$(oci os ns get | jq .data | tr -d '"')
WORK_REQUEST=$(oci compute image import from-object --namespace $NAMESPACE \
	--launch-mode PARAVIRTUALIZED --display-name debian-golden \
	--bucket-name debian-golden --name golden.raw-disk001.vmdk )
echo $WORK_REQUEST
WORK_REQUEST_ID=$(echo $WORK_REQUEST | jq '."opc-work-request-id"' | tr -d '"')
echo $WORK_REQUEST_ID
WORK_DISPLAY_NAME=$(echo $WORK_REQUEST | jq '.data."display-name"' | tr -d '"')
echo $WORK_DISPLAY_NAME
if [ $? -gt 0 ]; then exit 1; fi
while [ "$(oci work-requests work-request get --work-request-id $WORK_REQUEST_ID \
	| jq '.data.status')" != "SUCCEEDED" ]; do echo waiting; sleep 90; done
echo "SUCCESS importing $WORK_DISPLAY_NAME"
