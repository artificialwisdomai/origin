FROM debian:bookworm AS bookworm_cuda

###
#
# Define environment

WORKDIR /workspace


###
#
# Set global environment variables

ENV PYTORCH_VERSION="v2.3.1"
ENV CUDA_VERSION="12.5.1_555.42.06"
ENV PATH="$PATH:/usr/local/cuda/bin"
ENV DEBIAN_FRONTEND="noninteractive"
ENV NVIDIA_DRIVER_CAPABILITIES="compute,utility"
ENV NVIDIA_VISIBLE_DEVICES="all"
ENV VENV_PATH="/workspace/v"
ENV PYTHON_VENV="${VENV_PATH}/bin/python"
ENV PIP_BIN="${VENV_PATH}/bin/pip"

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

#ENV USE_UCC="ON"
ENV USE_MIMALLOC="ON"
ENV USE_NCCL="ON"

#ENV ATEN_THREADING="NATIVE"
#ENV USE_SYSTEM_LIBS ON

###
#
# Install toolchain and system dependencies

RUN apt update
RUN apt -y install build-essential
RUN apt -y install ca-certificates
#RUN apt -y install ccache
RUN apt -y install python3
RUN apt -y install python3-full
RUN apt -y install python3-venv
RUN apt -y install python3-pip
RUN apt -y install swig
RUN apt -y install ninja-build
RUN apt -y install git
RUN apt -y install cmake
RUN apt -y install gpg
RUN apt -y install curl
RUN apt -y install zstd

RUN apt -y install libnuma-dev
RUN apt -y install libssl-dev
RUN apt -y install libzstd-dev
RUN apt -y install libucx-dev
RUN apt -y install libmpfr-dev
RUN apt -y install libgmp3-dev
RUN apt -y install libfftw3-dev
#RUN apt -y install libmagma-dev


###
#
# Not sure if or why these are needed

RUN apt -y install libjpeg-dev
RUN apt -y install libpng-dev

#RUN /usr/sbin/update-ccache-symlinks
RUN mkdir -p /opt/ccache
#RUN ccache --set-config=cache_dir=/opt/ccache


###
#
# Setup build environment and clone pytorch

RUN mkdir -p /workspace/build
RUN mkdir -p /workspace/${PYTORCH_VERSION}
RUN mkdir -p /workspace/tmp
RUN mkdir -p /workspace/added
RUN mkdir -p /workspace/uncompressed
RUN mkdir -p /workspace/target
RUN mkdir -p /workspace/patches

RUN git clone --depth 1 --jobs ${MAX_JOBS} "https://github.com/pytorch/pytorch" --branch "${PYTORCH_VERSION}" --recurse-submodules --shallow-submodules build

###
#
#

COPY /workspace/patches/pytorch-compute-86-override.patch /workspace/patches
RUN patch --directory build -p1 pytorch-compute-86-override.patch

###
#
# Install NVIDIA CUDA SDK

RUN curl -LO https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb
RUN apt-get update
RUN apt -y install software-properties-common
RUN add-apt-repository contrib
RUN apt-get update
RUN apt -y install cuda-toolkit-12-5
RUN apt -y install libcusparselt-dev
RUN apt -y install cudnn


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
ENV BLA_STATIS=True


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
RUN ${PIP_BIN} install -r /workspace/build/requirements.txt


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
COPY --from=bookworm_cuda /workspace/build/dist /
