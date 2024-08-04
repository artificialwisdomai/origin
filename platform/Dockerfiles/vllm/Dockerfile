# syntax=docker/dockerfile:1
FROM docker.io/library/debian:12 AS build_vllm
LABEL "com.computelify.vendor"="Computelify, Inc."
LABEL "cloud.artificialwisdom.vendor"="The Artificial Wisdom Cloud"
LABEL "version"="v0.5.3"
LABEL "epoch"="0"
LABEL "description"="debian/vllm"

###
#
# Define environment

WORKDIR /workspace


###
#
# Set global environment variables

ENV VLLM_VERSION="v0.5.3"
ENV VLLM_EPOCH="0"
ENV CUDA_VERSION="12-6"
ENV PATH="$PATH:/usr/local/cuda/bin"
ENV DEBIAN_FRONTEND="noninteractive"
ENV NVIDIA_DRIVER_CAPABILITIES="compute,utility"
ENV NVIDIA_VISIBLE_DEVICES="all"
ENV VENV_PATH="/workspace/v"
ENV PYTHON_VENV="${VENV_PATH}/bin/python"
ENV PIP_BIN="${VENV_PATH}/bin/pip"
ENV Python_INCLUDE_DIRS="/usr/include/python3.11"


###
#
# Workaround gcc-12 issue:
# https://github.com/pytorch/pytorch/issues/77939#issuecomment-1526844015

ENV CXXFLAGS='-Wno-maybe-uninitialized -Wno-uninitialized -Wno-free-nonheap-object -Wno-dev'
ENV CFLAGS='-Wno-maybe-uninitialized -Wno-uninitialized -Wno-free-nonheap-object -Wno-dev'


###
#
# Set pytorch specific build environment variables

ENV REL_WITH_DEB_INFO="ON"
ENV MAX_JOBS="32"
ENV USE_CUDA="ON"
ENV USE_CUDNN=1
ENV USE_CUSPARSELT=1
ENV USE_FBGEMM="ON"
ENV USE_KINETO="ON"
ENV USE_NUMPY="ON"
ENV USE_NNPACK="ON"
ENV USE_DISTRIBUTED="ON"
ENV USE_TENSORPIPE="ON"
ENV USE_GLOO="ON"
ENV USE_MPI="ON"
ENV USE_SYSTEM_NCCL="OFF"
ENV USE_OPENMP="ON"
ENV USE_FLASH_ATTENTION="ON"
ENV USE_MEM_EFF_ATTENTION="ON"
ENV PYTORCH_BUILD_VERSION="2.3.1"
ENV PYTORCH_BUILD_NUMBER="1"
ENV TORCH_CUDA_ARCH_LIST="8.0;8.6;8.9;9.0"
ENV CUDA_PATH="/usr/local/cuda"
ENV CUDA_HOME="/usr/local/cuda"
ENV CUDA_TOOLKIT_ROOT_DIR="/usr/local/cuda"
ENV CUDA_NVCC_EXECUTABLE="/usr/local/cuda/bin/nvcc"
ENV CUDA_INCLUDE_DIRS="/usr/local/cuda/include"
ENV CUSPARSELT_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu"
ENV CUSPARSE_INCLUDE_PATH="/usr/include/x86_64-linux-gnu"
ENV CUDNN_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu"
ENV CUDNN_INCLUDE_PATH="/usr/include/x86_64-linux-gnu"
ENV USE_MIMALLOC="ON"
ENV USE_NCCL="ON"


###
#
# Install toolchain and system dependencies

RUN apt update


RUN apt --yes install build-essential
RUN apt --yes install ca-certificates
RUN apt --yes install python3
RUN apt --yes install python3-full
RUN apt --yes install python3-venv
RUN apt --yes install python3-pip
RUN apt --yes install python3-dev
RUN apt --yes install libpython3-dev
RUN apt --yes install libpython3.11-dev
RUN apt --yes install swig
RUN apt --yes install ninja-build
RUN apt --yes install git
RUN apt --yes install cmake
RUN apt --yes install gpg
RUN apt --yes install curl
RUN apt --yes install zstd
RUN apt --yes install gnupg
RUN apt --yes install cython3

RUN apt --yes install libnuma-dev
RUN apt --yes install libssl-dev
RUN apt --yes install libzstd-dev
RUN apt --yes install libucx-dev
RUN apt --yes install libmpfr-dev
RUN apt --yes install libgmp3-dev
RUN apt --yes install libfftw3-dev


###
#
# Not sure if or why these are needed

RUN apt --yes install libjpeg-dev
RUN apt --yes install libpng-dev


###
#
# Setup build environment and clone pytorch

RUN mkdir --parents /workspace/build
RUN mkdir --parents /workspace/${PYTORCH_VERSION}
RUN mkdir --parents /workspace/tmp
RUN mkdir --parents /workspace/added
RUN mkdir --parents /workspace/uncompressed
RUN mkdir --parents /workspace/target
RUN mkdir --parents /workspace/patches

RUN git clone --depth 1 --jobs ${MAX_JOBS} "https://github.com/vllm-project/vllm.git" --branch "${VLLM_VERSION}" --recurse-submodules --shallow-submodules build


###
#
# Install NVIDIA CUDA SDK

RUN curl -LO https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb
RUN apt-get update
RUN apt --yes install software-properties-common
RUN add-apt-repository contrib
RUN apt-get update
RUN apt --yes install cuda-toolkit-${CUDA_VERSION}
RUN apt --yes install libcusparselt-dev
RUN apt --yes install cudnn


###
#
# Install Intel MKL BLAS

RUN curl --location "https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB" | gpg --dearmor > /usr/share/keyrings/oneapi-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" > /etc/apt/sources.list.d/oneAPI.list

RUN apt update
RUN apt install -y intel-oneapi-mkl
RUN apt install -y intel-oneapi-mkl-devel

ENV MKL_VERSION="2024.2"
ENV MKL_ROOT="/opt/intel/oneapi/mkl/${MKL_VERSION}/lib/intel64"
ENV MKL_MODEL="ilp64"
ENV MKL_LIBRARIES="-Wl,--start-group;${MKL_ROOT}/libmkl_intel_${MKL_MODEL}.a;${MKL_ROOT}/libmkl_gnu_thread.a;${MKL_ROOT}/libmkl_core.a;-Wl,--end-group"
ENV CUDA_ARCHS="80;86;89;90"
ENV BLA_VENDOR=Intel10_64ilp
ENV BLA_STATIC=True


###
#
# Install Python virtual environmnet

RUN python3 -m venv ${VENV_PATH}
RUN ${PIP_BIN} install six
RUN ${PIP_BIN} install numpy
RUN ${PIP_BIN} install swig
RUN ${PIP_BIN} install build
RUN ${PIP_BIN} install wheel
RUN ${PIP_BIN} install pyyaml
RUN ${PIP_BIN} install cmake
RUN ${PIP_BIN} install ninja
RUN ${PIP_BIN} install -r /workspace/build/requirements-cuda.txt


###
#
# Hardcode the cuda library path for the system loader

RUN echo "/opt/nvidia/cuda/lib64" > /etc/ld.so.conf.d/cuda.conf
RUN ldconfig -v


###
#
# Build pytorch

WORKDIR /workspace/build
RUN ${PYTHON_VENV} -m build --wheel --sdist --no-isolation


###
#
# Produce a clean image of build results for output from buildx

FROM scratch
COPY --from=build_vllm /workspace/build/dist /
