RUST_HYPERVISOR_FIRMWARE_VERSION=v0.4.2
RUST_HYPERVISOR_FIRMWARE_EPOCH=0
date=$(date '+%Y%m%d%H%M%S')

docker buildx build --tag artificialwisdomai/rust-hypervisor-version:${RUST_HYPERVISOR_FIRMWARE_VERSION}-${RUST_HYPERVISOR_FIRMWARE_EPOCH}-${date} --output type=docker --progress plain .
docker buildx build --tag artificialwisdomai/rust-hypervisor-version:${RUST_HYPERVISOR_FIRMWARE_VERSION}-${RUST_HYPERVISOR_FIRMWARE_EPOCH}-${date} --output type=local,dest="${PWD}/target" --progress plain .
docker buildx build --tag artificialwisdomai/crust-hypervisor-version:${RUST_HYPERVISOR_FIRMWARE_VERSION}-${RUST_HYPERVISOR_FIRMWARE_EPOCH} --output type=docker --progress plain .
