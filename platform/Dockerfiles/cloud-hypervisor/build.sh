CLOUD_HYPERVISOR_VERSION=40.0
TOOLCHAIN_REVISION=20240812
date=$(date '+%Y%m%d%H%M%S')

docker buildx build --build-arg TOOLCHAIN_REVISION=${TOOLCHAIN_REVISION} --tag artificialwisdomai/cloud-hypervisor:v${CLOUD_HYPERVISOR_VERSION} --output type=docker --progress plain .
docker buildx build --build-arg TOOLCHAIN_REVISION=${TOOLCHAIN_REVISION} --tag artificialwisdomai/cloud-hypervisor:v${CLOUD_HYPERVISOR_VERSION}-${date} --output type=docker --progress plain .
docker buildx build --build-arg TOOLCHAIN_REVISION=${TOOLCHAIN_REVISION} --tag artificialwisdomai/cloud-hypervisor:v${CLOUD_HYPERVISOR_VERSION}-${date} --output type=local,dest="${PWD}/target" --progress plain .
