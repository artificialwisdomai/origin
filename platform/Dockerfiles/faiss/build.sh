date=$(date '+%Y%m%d%H%M%S')
FAISS_VERSION=1.8.0
TOOLCHAIN_REVISION=20240813

docker buildx build --build-arg TOOLCHAIN_REVISION=${TOOLCHAIN_REVISION} --tag artificialwisdomai/faiss:v${FAISS_VERSION}.0-${date} --output type=local,dest="${PWD}/target" --progress plain .
docker buildx build --build-arg TOOLCHAIN_REVISION=${TOOLCHAIN_REVISION} --tag artificialwisdomai/faiss:v${FAISS_VERSION}.0 --tag --output type=docker --progress plain .
docker buildx build --build-arg TOOLCHAIN_REVISION=${TOOLCHAIN_REVISION} --tag artificialwisdomai/faiss:v${FAISS_VERSION}.0-${date} --output type=docker --progress plain .
