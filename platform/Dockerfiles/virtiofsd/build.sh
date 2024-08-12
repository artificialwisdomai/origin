date=$(date '+%Y%m%d%H%M%S')
VIRTIOFSD_VERSION=1.11.1
TOOLCHAIN_REVISION=20240812

docker buildx build --build-arg TOOLCHAIN_REVISION=${TOOLCHAIN_REVISION} --progress=plain --tag artificialwisdomai/virtiofsd:v${VIRTIOFSD_VERSION}-${date} --output type=local,dest="${PWD}/target" --progress plain .
docker buildx build --build-arg TOOLCHAIN_REVISION=${TOOLCHAIN_REVISION} --progress=plain --tag artificialwisdomai/virtiofsd:v${VIRTIOFSD_VERSION}-${date} --output type=docker --progress plain .
docker buildx build --build-arg TOOLCHAIN_REVISION=${TOOLCHAIN_REVISION} --progress=plain --tag artificialwisdomai/virtiofsd:v${VIRTIOFSD_VERSION} --output type=docker --progress plain .
