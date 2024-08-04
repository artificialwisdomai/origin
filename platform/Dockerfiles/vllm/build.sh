###
#
# Build pytorch and output the build results to  "${PWD}/target"

VLLM_VERSION=v0.5.3
VLLM_EPOCH=0
date=$(date '+%Y%m%d%H%M%S')

docker buildx build --tag artificialwisdomai/vllm:${VLLM_VERSION}-${VLLM_EPOCH} --output type=docker --progress plain .
docker buildx build --tag artificialwisdomai/vllm:${VLLM_VERSION}-${VLLM_EPOCH}-${date} --output type=local,dest="${PWD}/target" --progress plain .
docker buildx build --tag artificialwisdomai/vllm:${VLLM_VERSION}-${VLLM_EPOCH}-${date} --output type=docker --progress plain .
