TOOLCHAIN_REVISION=20240812
FLASHINFER_VERSION=v0.1.4
FLASHINFER_EPOCH=0
date=$(date '+%Y%m%d%H%M%S')

docker buildx build --build-args TOOLCHAIN_REVISION=${TOOLCHAIN_REVISION} --tag artificialwisdomai/flashinfer:${FLASHINFER_VERSION}-${FLASHINFER_EPOCH}-${date} --output type=docker --progress plain .
docker buildx build --build-args TOOLCHAIN_REVISION=${TOOLCHAIN_REVISION} --tag artificialwisdomai/flashinfer:${FLASHINFER_VERSION}-${FLASHINFER_EPOCH}-${date} --output type=local,dest="${PWD}/target" --progress plain .
docker buildx build --build-args TOOLCHAIN_REVISION=${TOOLCHAIN_REVISION} --tag artificialwisdomai/flashinfer:${FLASHINFER_VERSION}-${FLASHINFER_EPOCH} --output type=docker --progress plain .
