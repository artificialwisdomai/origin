###
#
# Build pytorch and output the build results to  "${PWD}/target"

LLM_COMPRESSOR_VERSION=v0.4.3
LLM_COMPRESSOR_EPOCH=0
date=$(date '+%Y%m%d%H%M%S')

docker buildx build --tag artificialwisdomai/llm_compressor:${LLM_COMPRESSOR_VERSION}-${LLM_COMPRESSOR_EPOCH} --output type=docker --progress plain .
docker buildx build --tag artificialwisdomai/llm_compressor:${LLM-COMPRESSOR_VERSION}-${LLM_COMPRESSOR_EPOCH}-${date} --output type=local,dest="${PWD}/target" --progress plain .
docker buildx build --tag artificialwisdomai/llm_compressor:${LLM_COMPRESSOR_VERSION}-${LLM_COMPRESSOR_EPOCH}-${date} --output type=docker --progress plain .
