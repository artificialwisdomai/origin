ISTIOD_VERSION=v1.22.5
date=$(date '+%Y%m%d%H%M%S')

docker buildx build --tag artificialwisdomai/istiod:${ISTIOD_VERSION}-${date} --output type=docker --progress plain .
docker buildx build --tag artificialwisdomai/istiod:${ISTIOD_VERSION}-${date} --output type=local,dest="${PWD}/target" --progress plain .
docker buildx build --tag artificialwisdomai/istiod:${ISTIOD_VERSION} --output type=docker --progress plain .
