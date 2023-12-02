date=$(date '+%Y%m%d%H%M%S')

docker buildx build -t artificialwisdomai/faiss:v1.7.4-${date} -t artificialwisdomai/faiss:v1.7.4 --output type=local,dest="${PWD}/target" --progress plain .
