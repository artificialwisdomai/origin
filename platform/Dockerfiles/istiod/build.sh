ISTIOD_VERSION=v1.22.5
TOOLCHAIN_REVISION=20240813
date=$(date '+%Y%m%d%H%M%S')

docker buildx build --build-arg TOOLCHAIN_REVISION=${TOOLCHAIN_REVISION} --tag artificialwisdomai/istiod:${ISTIOD_VERSION}-${date} --output type=docker --progress plain .
docker buildx build --build-arg TOOLCHAIN_REVISION=${TOOLCHAIN_REVISION} --tag artificialwisdomai/istiod:${ISTIOD_VERSION}-${date} --output type=local,dest="${PWD}/target" --progress plain .
docker buildx build --build-arg TOOLCHAIN_REVISION=${TOOLCHAIN_REVISION} --tag artificialwisdomai/istiod:${ISTIOD_VERSION} --output type=docker --progress plain .
