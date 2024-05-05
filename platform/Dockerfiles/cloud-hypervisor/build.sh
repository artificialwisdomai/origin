CLOUD_HYPERVISOR_VERSION=v39.0
date=$(date '+%Y%m%d%H%M%S')

docker buildx build --tag artificialwisdomai/cloud-hypervisor:${CLOUD_HYPERVISOR_VERSION}-${date} --output type=docker --progress plain .
docker buildx build --tag artificialwisdomai/cloud-hypervisor:${CLOUD_HYPERVISOR_VERSION}-${date} --output type=local,dest="${PWD}/target" --progress plain .
docker buildx build --tag artificialwisdomai/cloud-hypervisor:${CLOUD_HYPERVISOR_VERSION} --output type=docker --progress plain .
