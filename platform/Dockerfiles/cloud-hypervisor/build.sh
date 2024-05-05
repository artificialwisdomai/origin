date=$(date '+%Y%m%d%H%M%S')

docker buildx build --tag artificialwisdomai/cloud-hypervisor:v39.0-${date} --output type=docker --progress plain .
docker buildx build --tag artificialwisdomai/cloud-hypervisor:v39.0-${date} --output type=local,dest="${PWD}/target" --progress plain .
docker buildx build --tag artificialwisdomai/cloud-hypervisor:v39.0 --output type=docker --progress plain .
