ARG TOOLCHAIN_REVISION="undefined"
FROM artificialwisdomai/toolchain:${TOOLCHAIN_REVISION} AS pytorch

# syntax=docker/dockerfile:1
LABEL "com.computelify.vendor"="Computelify, Inc."
LABEL "cloud.artificialwisdom.vendor"="The Artificial Wisdom Cloud"
LABEL "version"="v2.4.0"
LABEL "epoch"="0"
LABEL "description"="debian/pytorch"


###
#
# Define environment

WORKDIR /workspace


###
#
# Set global environment variables

ENV PYTORCH_VERSION="2.4.0"
ENV PYTORCH_EPOCH="0"

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
ENV PYTORCH_BUILD_VERSION="${PYTORCH_VERSION}"
ENV PYTORCH_BUILD_NUMBER="${PYTORCH_EPOCH}"
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
# Setup build environment and clone pytorch

RUN mkdir -p /workspace/build
RUN mkdir -p /workspace/v${PYTORCH_VERSION}
RUN mkdir -p /workspace/tmp
RUN mkdir -p /workspace/added
RUN mkdir -p /workspace/uncompressed
RUN mkdir -p /workspace/target
RUN mkdir -p /workspace/patches

RUN git clone --depth 1 --jobs ${MAX_JOBS} "https://github.com/pytorch/pytorch" --branch "v${PYTORCH_VERSION}" --recurse-submodules --shallow-submodules build


###
#
#

COPY pytorch-compute-86-override.patch /workspace/patches
RUN patch --directory build --strip 1 /workspace/patches/pytorch-compute-86-override.patch


###
#
# Install Python virtual environmnet

RUN ${PIP} install six
RUN ${PIP} install numpy
RUN ${PIP} install pyyaml


###
#
# Build pytorch

WORKDIR /workspace/build
RUN ${PYTHON} -m build --wheel --sdist --no-isolation


###
#
# Produce a clean image of build results for output from buildx

FROM scratch
COPY --from=pytorch /workspace/build/dist /
