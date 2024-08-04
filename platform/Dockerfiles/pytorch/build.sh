###
#
# Build pytorch and output the build results to  "${PWD}/target"

date=$(date '+%Y%m%d%H%M%S')
PYTORCH_VERSION=2.4.0
PYTORCH_EPOCH=0

docker buildx build --tag artificialwisdomai/pytorch:v${PYTORCH_VERSION}_${PYTORCH_EPOCH} --output type=docker --progress plain .
docker buildx build --tag artificialwisdomai/pytorch:v${PYTORCH_VERSION}_${PYTORCH_EPOCH}-${date} --output type=docker --progress plain .
docker buildx build --tag artificialwisdomai/pytorch:v${PYTORCH_VERSION}_${PYTORCH_EPOCH}-${date} --output type=local,dest="${PWD}/target" --progress plain .
