cd build
if ! $(oci os bucket list | grep debian-golden >& /dev/null)
then
  oci os bucket create --bucket-name debian-golden
fi
if -f golden.raw-disk001.vmdk
then
  oci os object put --bucket-name debian-golden --file golden.raw-disk001.vmdk
else
  echo no vmdk to upload!
fi
oci compute image import from-object --namespace $(oci os ns get | jq .data | tr -d '"') \
 --bucket-name debian-golden --name golden.raw-disk001.vmdk > oci-import.out

cd ..
