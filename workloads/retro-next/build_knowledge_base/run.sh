####
#
# Workflow requires GPUs. There is no way to run on classical compute.

# https://docs.docker.com/engine/reference/commandline/run/
# https://github.com/NVIDIA/nvidia-docker/issues/1268#issuecomment-632692949
#
# TLDR;
# sudo apt install nvidia-container-toolkit
# sudo systemctl restart docker

docker run --init --gpus all --rm artificialwisdomai/build_knowledge_base:latest
