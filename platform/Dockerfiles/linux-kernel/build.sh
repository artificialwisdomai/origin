###
#
# Build linux-kernel and output the build results to  "${PWD}/target"

date=$(date '+%Y%m%d%H%M%S')
LINUX_KERNEL_VERSION=6.1.99
LINUX_KERNEL_EPOCH=0

docker buildx build --tag artificialwisdomai/linux-kernel:v${LINUX_KERNEL_VERSION}_${LINUX_KERNEL_EPOCH} --tag --output type=docker --progress plain .
docker buildx build --tag artificialwisdomai/linux-kernel:v${LINUX_KERNEL_VERSION}_${LINUX_KERNEL_EPOCH}-${date} --output type=docker --progress plain .
docker buildx build --tag artificialwisdomai/linux-kernel:v${LINUX_KERNEL_VERSION}_${LINUX_KERNEL_EPOCH}-${date} --output type=local,dest="${PWD}/target" --progress plain .
