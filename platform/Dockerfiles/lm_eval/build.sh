###
#
# Build pytorch and output the build results to  "${PWD}/target"

LMEVAL_VERSION=v0.4.3
LMEVAL_EPOCH=0
date=$(date '+%Y%m%d%H%M%S')

docker buildx build --tag artificialwisdomai/lmeval:${LMEVAL_VERSION}-${LMEVAL_EPOCH} --output type=docker --progress plain .
docker buildx build --tag artificialwisdomai/lmeval:${LMEVAL_VERSION}-${LMEVAL_EPOCH}-${date} --output type=local,dest="${PWD}/target" --progress plain .
docker buildx build --tag artificialwisdomai/lmeval:${LMEVAL_VERSION}-${LMEVAL_EPOCH}-${date} --output type=docker --progress plain .
