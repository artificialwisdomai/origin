###
#
# Build from source:
#   https://github.com/pytorch/pytorch#from-source

ARG BASE_IMAGE=debian:bookworm-slim
FROM ${BASE_IMAGE}

LABEL com.nvidia.volumes.needed="nvidia_driver"

ARG PYTHON_VERSION="3.11"
ARG TORCH_CUDA_ARCH_LIST="8.0"
ARG TORCH_NVCC_FLAGS="-Xfatbit -compress-all"
ARG CUDA_VERSION="12.1"
ARG TARGETPLATFORM="amd64"
#ARG PYTORCH_VERSION
#ARG TRITON_VERSION
#ARG TARGETPLATFORM

###
#
# Set the environment

ENV NVIDIA_VISIBLE_DEVICES="all"
ENV NVIDIA_DRIVER_CAPABILITIES="compute,utility"
ENV LIBRARY_PATH="/usr/local/nvidia/lib:/usr/local/nvidia/lib64:$LIBRARY_PATH"
ENV LD_LIBRARY_PATH="/usr/local/nvidia/lib:/usr/local/nvidia/lib64:$LD_LIBRARY_PATH"
ENV PYTORCH_VERSION="${PYTORCH_VERSION}"
ENV PATH="/usr/lib/ccache:$PATH"
ENV _GLIBCXX_USE_CXX11_ABI="1"

###
#
# Image build instructions

RUN apt -y update
RUN apt -y upgrade

###
#
# Install dependencies

run DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        ccache \
        cmake \
        curl \
        git \
        libjpeg-dev \
        libpng-dev \
	gcc \
	curl \
	python3
#        ninja

COPY sources.list /etc/apt/

###
#
# this section is from the NVIDIA CUDA download page
# https://developer.nvidia.com/cuda-downloads

RUN curl -LO https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb
#RUN add-apt-repository contrib
RUN apt -y update
RUN apt -y upgrade
RUN cat /etc/apt/sources.list >&2
RUN apt -y install cuda

###
#
# Prepare the ccache

RUN /usr/sbin/update-ccache-symlinks
RUN mkdir /opt/ccache
RUN ccache --set-config=cache_dir=/opt/ccache

###
# 
# Clone and build

WORKDIR /opt/
RUN git clone https://github.com/pytorch/pytorch
WORKDIR /opt/pytorch/
RUN git submodule update --init --recursive
RUN python3 setup.py build --cmake-only
RUN ccmake build  # o
