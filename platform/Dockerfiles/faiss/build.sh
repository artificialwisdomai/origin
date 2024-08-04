date=$(date '+%Y%m%d%H%M%S')
FAISS_VERSION=1.8.0

docker buildx build --tag artificialwisdomai/faiss:v${FAISS_VERSION}.0-${date} --output type=local,dest="${PWD}/target" --progress plain .
docker buildx build --tag artificialwisdomai/faiss:v${FAISS_VERSION}.0 --tag --output type=docker --progress plain .
docker buildx build --tag artificialwisdomai/faiss:v${FAISS_VERSION}.0-${date} --output type=docker --progress plain .
