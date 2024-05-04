date=$(date '+%Y%m%d%H%M%S')

docker buildx build --progress=plain -t artificialwisdomai/virtiofsd:v1.8.0-${date} -t artificialwisdomai/cloud-hypervisor:v1.8.0 --output type=local,dest="${PWD}/target" --progress plain .
