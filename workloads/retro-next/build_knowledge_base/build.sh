# Build with docker

date=$(date '+%Y%m%d%H%M%S')

docker buildx build . -t artificialwisdomai/build_knowledge_base:${date}
docker tag artificialwisdomai/build_knowledge_base:${date} artificialwisdomai/build_knowledge_base:latest
