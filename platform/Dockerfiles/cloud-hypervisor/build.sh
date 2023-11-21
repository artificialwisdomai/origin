date=$(date '+%Y%m%d%H%M%S')

docker buildx build -t artificialwisdomai/cloud-hypervisor:v36.0-${date} -t artificialwisdomai/cloud-hypervisor:v36.0 --output type=local,dest="${PWD}/target" --progress plain .
