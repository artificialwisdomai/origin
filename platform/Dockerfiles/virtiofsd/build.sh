date=$(date '+%Y%m%d%H%M%S')
VIRTIOFSD_VERSION=v1.10.1

docker buildx build --progress=plain --tag artificialwisdomai/virtiofsd:${VIRTIOFSD_VERSION}-${date} --output type=local,dest="${PWD}/target" --progress plain .
docker buildx build --progress=plain --tag artificialwisdomai/virtiofsd:${VIRTIOFSD_VERSION}-${date} --output type=docker --progress plain .
docker buildx build --progress=plain --tag artificialwisdomai/virtiofsd:${VIRTIOFSD_VERSION} --output type=docker --progress plain .
