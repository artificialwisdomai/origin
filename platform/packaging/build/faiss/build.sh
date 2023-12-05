date=$(date '+%Y%m%d%H%M%S')

docker buildx build --tag artificialwisdomai/faiss:v1.7.4.0-${date} --tag artificialwisdomai/faiss:v1.7.4.0 --output type=local,dest="${PWD}/target" --progress plain .
