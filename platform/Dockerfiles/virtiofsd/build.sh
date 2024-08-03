date=$(date '+%Y%m%d%H%M%S')
VIRTIOFSD_VERSION=1.11.1

docker buildx build --progress=plain --tag artificialwisdomai/virtiofsd:v${VIRTIOFSD_VERSION}-${date} --output type=local,dest="${PWD}/target" --progress plain .
docker buildx build --progress=plain --tag artificialwisdomai/virtiofsd:v${VIRTIOFSD_VERSION}-${date} --output type=docker --progress plain .
docker buildx build --progress=plain --tag artificialwisdomai/virtiofsd:v${VIRTIOFSD_VERSION} --output type=docker --progress plain .
