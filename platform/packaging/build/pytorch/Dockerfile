FROM debian:bookworm AS bookworm_cuda

###
#
# Define environment

WORKDIR /workspace

ENV PYTORCH_VERSION="v2.0.1"
ENV PATH="$PATH:/usr/local/cuda/bin"
ENV DEBIAN_FRONTEND="noninteractive"
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_VISIBLE_DEVICES all
###
#
# Workaround gcc-12 issue:
# https://github.com/pytorch/pytorch/issues/77939#issuecomment-1526844015

ENV CXXFLAGS='-Wno-maybe-uninitialized -Wno-uninitialized -Wno-free-nonheap-object'
ENV CFLAGS='-Wno-maybe-uninitialized -Wno-uninitialized -Wno-free-nonheap-object'

###
#
# Not all of these environment variables are used
# This list of config options should be audited for correctness

#ENV T_NCCL_INCLUDE_DIRS="PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/comm_libs/12.2/nccl/include"
#ENV T_NCCL_LIBRARIES="PATH=/opt/nvidia/hpc_sdk/Linux_x86_64/23.7/comm_libs/12.2/nccl/lib"
#-DNCCL_INCLUDE_DIRS:${T_NCCL_INCLUDE_DIRS} -DNCCL_LIBRARIES:${T_NCCL_LIBRARIES} -DMAX_JOBS:${T_MAX_JOBS}
ENV T_TORCH_CUDA_ARCH_LIST="STRING=8.0;8.6"
ENV T_MAX_JOBS="INTEGER=30"
ENV T_USE_CUDNN="BOOL=TRUE"
ENV T_USE_CUSPARSELT="BOOL=TRUE"
ENV T_USE_FBGEMM="BOOL=TRUE"
ENV T_USE_KINETO="BOOL=TRUE"
ENV T_USE_NUMPY="BOOL=TRUE"
ENV T_USE_NNPACK="BOOL=TRUE"
ENV T_USE_QNNPACK="BOOL=TRUE"
ENV T_USE_SYSTEM_NCCL="BOOL=FALSE"
ENV T_USE_NCCL="BOOL=FALSE"
ENV T_BUILD_CAFFE2="BOOL=TRUE"
ENV T_BUILD_CAFFE2_OPS="BOOL=TRUE"
ENV T_USE_FLASH_ATTENTION="BOOL=TRUE"
ENV T_BUILD_BINARY="BOOL=TRUE"
ENV T_BLAS="BOOL=TRUE"
ENV T_USE_ZSTD="BOOL=TRUE"


#CUDA_TOOLKIT_ROOT_DIR="/usr/local/cuda"
#CUDA_HOME="/usr/local/cuda"
#CUDA_NVCC_EXECUTABLE="/usr/local/cuda/bin/nvcc"
#ATEN_THREADING="NATIVE"
#USE_SYSTEM_LIBS=1

###
#
# Define dependencies

RUN apt update
RUN apt -y install build-essential
RUN apt -y install ca-certificates
#RUN apt -y install ccache
RUN apt -y install cmake
RUN apt -y install curl
RUN apt -y install git
RUN apt -y install python3
RUN apt -y install libnuma-dev
RUN apt -y install libssl-dev
RUN apt -y install libzstd-dev

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
# Install CUDA

RUN mkdir -p /usr/local/cuda
RUN mkdir -p /workspace/build
RUN mkdir -p /workspace/${PYTORCH_VERSION}
RUN mkdir -p /workspace/tmp
RUN mkdir -p /workspace/added
RUN mkdir -p /workspace/uncompressed
RUN mkdir -p /workspace/target

RUN git clone --recurse "https://github.com/pytorch/pytorch" "v2.0.1"

###
#
# Install NVIDIA CUDA SDK

ADD https://developer.download.nvidia.com/compute/cuda/12.2.1/local_installers/cuda_12.2.1_535.86.10_linux.run /workspace/added
RUN bash /workspace/added/cuda_12.2.1_535.86.10_linux.run --extract=/workspace/uncompressed/cuda_12.2.1_535
RUN for d in /workspace/uncompressed/cuda_12.2.1_535/cuda*; do cp -aR "${d}"/* /usr/local/cuda; done
RUN for d in /workspace/uncompressed/cuda_12.2.1_535/lib*; do cp -aR "${d}"/* /usr/local/cuda; done

###
#
# Install NVIDIA HPC SDK

ADD https://developer.download.nvidia.com/hpc-sdk/23.7/nvhpc_2023_237_Linux_x86_64_cuda_12.2.tar.gz /workspace/added
RUN tar -xf /workspace/added/nvhpc_2023_237_Linux_x86_64_cuda_12.2.tar.gz --directory /workspace/uncompressed
RUN NVHPC_SILENT=true bash /workspace/uncompressed/nvhpc_2023_237_Linux_x86_64_cuda_12.2/install_components/install
RUN find /opt -name "*.so" -exec dirname {} \; | sort -u > /etc/ld.so.conf.d/artificial_wisdom_ldso.conf

RUN apt update
RUN apt -y install python3.11
RUN apt -y install python3.11-dev
RUN apt -y install python3-pip
RUN apt -y install ninja-build
RUN dpkg-divert --rename --add /usr/lib/$(py3versions -d)/EXTERNALLY-MANAGED

RUN pip3 install --user pyyaml
RUN pip3 install --user numpy

###
#
# Build pytorch

RUN rm -rf /workspace/build
WORKDIR /workspace/build
RUN cmake -DUSE_NCCL:${T_USE_NCCL} -DUSE_SYSTEM_NCCL:${T_USE_SYSTEM_NCCL} -DCMAKE_GENERATOR:INTERNAL=Ninja -DCMAKE_INSTALL:INTERNAL="ninja install" -DTORCH_CUDA_ARCH_LIST:${T_TORCH_CUDA_ARCH_LIST} -DBUILD_SHARED_LIBS:BOOL=ON -DCUDA_TOOLKIT_ROOT_DIR:PATH=/usr/local/cuda -DCUDA_NVCC_EXECUTABLE:PATH=/usr/local/cuda/bin/nvcc -DCUSPARSELT_LIBRARY_PATH:PATH=/usr/local/cuparse/lib -DCMAKE_BUILD_TYPE:STRING=Release -DPYTHON_EXECUTABLE:PATH=`which python3` -DUSE_CUDA:BOOL=TRUE -DUSE_ZSTD:BOOL=TRUE -DCMAKE_INSTALL_PREFIX:PATH=/workspace/target /workspace/${PYTORCH_VERSION}
RUN ninja
RUN ninja install
RUN python setup.py bdist_wheel

#RUN grep NOT /workspace/pytorch/build/typescript

###
#
# Produce a clean image of build results for output from buildx

FROM scratch
COPY --from=bookworm_cuda /workspace/target /libtorch
COPY --from=bookworm_cuda /workspace/build /python
