RUST_HYPERVISOR_FW_VERSION=v0.4.2
RUST_HYPERVISOR_FW_EPOCH=0
date=$(date '+%Y%m%d%H%M%S')

docker buildx build --tag artificialwisdomai/rust-hypervisor-firmware:${RUST_HYPERVISOR_FW_VERSION}-${RUST_HYPERVISOR_FW_EPOCH}-${date} --output type=docker --progress plain .
docker buildx build --tag artificialwisdomai/rust-hypervisor-firmware:${RUST_HYPERVISOR_FW_VERSION}-${RUST_HYPERVISOR_FW_EPOCH}-${date} --output type=local,dest="${PWD}/target" --progress plain .
docker buildx build --tag artificialwisdomai/rust-hypervisor-firmware:${RUST_HYPERVISOR_FW_VERSION}-${RUST_HYPERVISOR_FW_EPOCH} --output type=docker --progress plain .
