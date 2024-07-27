###
#
# Build pytorch and output the build results to  "${PWD}/target"

mkdir -p "${PWD}/target"
docker buildx build --progress plain --output type=local,dest="${PWD}/target" . -t pytorch:v2.3.1
