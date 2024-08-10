# syntax=docker/dockerfile:1
FROM artificialwisdomai/toolchain:20240809 AS build_vllm

LABEL "com.computelify.vendor"="Computelify, Inc."
LABEL "cloud.artificialwisdom.vendor"="The Artificial Wisdom Cloud"
LABEL "version"="v0.5.4"
LABEL "epoch"="0"
LABEL "description"="debian/vllm"

###
#
# Define environment

WORKDIR /workspace
RUN mkdir -p /workspace/target


###
#
# Set global environment variables

ENV VLLM_VERSION="v0.5.4"
ENV VLLM_EPOCH="0"
ENV CUDA_VERSION="12-6"
ENV CUDA_HOME=/usr/local/cuda
ENV PATH="$PATH:/usr/local/cuda/bin:/workspace/v/bin"
ENV DEBIAN_FRONTEND="noninteractive"
ENV NVIDIA_DRIVER_CAPABILITIES="compute,utility"
ENV NVIDIA_VISIBLE_DEVICES="all"
ENV VENV_PATH="/workspace/v"
ENV PIP="${VENV_PATH}/bin/pip"
ENV PYTHON="${VENV_PATH}/bin/python"
ENV PYTHON_EXECUTABLE="${PYTHON}"
ENV VLLM_PYTHON_EXECUTABLE=${PYTHON}

###
#
# Set vllm specific build environment variables

ENV VLLM_TARGET_DEVICE="cuda"
ENV CMAKE_BUILD_TYPE="Release"
ENV CUDA_HOME="/usr/local/cuda"
ENV NVCC_THREADS="32"
ENV MAX_JOBS="32"
ENV MAIN_CUDA_VERSION="12.6"
ENV CUDA_SUPPORTED_ARCHS="8.0;8.6;8.9;9.0"
ENV USE_CUDNN=1
ENV USE_CUSPARSELT=1

RUN git clone --depth 1 --jobs ${MAX_JOBS} "https://github.com/vllm-project/vllm.git" --branch "${VLLM_VERSION}" --recurse-submodules --shallow-submodules build

###
#
# Build vllm

WORKDIR /workspace/build
RUN ${PIP} install torch
RUN ${PIP} install numpy

RUN ${PYTHON} -m build --wheel --no-isolation
RUN cp -aR dist/* /workspace/target


###
#
# Produce a clean image of build results for output from buildx

FROM scratch
COPY --from=build_vllm /workspace/target /
