mkdir -p "${PWD}/target"
docker buildx build --output type=local,dest="${PWD}/target" . -t baseline:bookworm_cuda122
