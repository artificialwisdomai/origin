# syntax=docker/dockerfile:1
FROM artificialwisdomai/toolchain:20240809 AS build_lmeval

LABEL "com.computelify.vendor"="Computelify, Inc."
LABEL "cloud.artificialwisdom.vendor"="The Artificial Wisdom Cloud"
LABEL "version"="v0.4.3"
LABEL "epoch"="0"
LABEL "description"="debian/lmeval"

###
#
# Define environment

WORKDIR /workspace
RUN mkdir -p /workspace/target


###
#
# Set global environment variables

ENV LMEVAL_VERSION="v0.4.3"
ENV LMEVAL_EPOCH="0"
ENV CUDA_VERSION="12-6"
ENV CUDA_HOME=/usr/local/cuda
ENV PATH="$PATH:/usr/local/cuda/bin:/workspace/v/bin"
ENV DEBIAN_FRONTEND="noninteractive"
ENV NVIDIA_DRIVER_CAPABILITIES="compute,utility"
ENV VENV_PATH="/workspace/v"
ENV PIP="${VENV_PATH}/bin/pip"
ENV PYTHON="${VENV_PATH}/bin/python"

###
#
# Set lmeval specific build environment variables

ENV CMAKE_BUILD_TYPE="Release"
ENV CUDA_HOME="/usr/local/cuda"
ENV NVCC_THREADS="32"
ENV MAX_JOBS="32"
ENV MAIN_CUDA_VERSION="12.6"
ENV CUDA_SUPPORTED_ARCHS="8.0;8.6;8.9;9.0"

RUN git clone --depth 1 --jobs ${MAX_JOBS} "https://github.com/EleutherAI/lm-evaluation-harness" --branch "${LMEVAL_VERSION}" --recurse-submodules --shallow-submodules build


###
#
# Build lmeval

WORKDIR /workspace/build
RUN ${PIP} install wheel
RUN ${PIP} wheel -r requirements.txt
RUN ${PYTHON} -m build --wheel --no-isolation
RUN cp -aR dist/* /workspace/target


###
#
# Produce a clean image of build results for output from buildx

FROM scratch
COPY --from=build_lmeval /workspace/target /
