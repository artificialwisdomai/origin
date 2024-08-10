###
#
#
date=$(date +%Y%m%d)

mkdir -p "${PWD}/target"
docker buildx build --tag artificialwisdomai/toolchain:${date} --progress plain --output type=docker --progress plain .
