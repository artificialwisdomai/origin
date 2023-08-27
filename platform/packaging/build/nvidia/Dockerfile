iFROM debian:bookworm AS bookworm_nvidia

###
#
# Define environment

WORKDIR /workspace

###
#
# Define dependencies

RUN apt -y update
RUN apt -y install zstd
RUN apt -y install curl
RUN apt -y install libxml2
RUN apt -y install lbzip2

###
#
# Install CUDA

RUN mkdir -p /workspace/added
RUN mkdir -p /workspace/uncompressed
RUN mkdir -p /workspace/build
RUN mkdir -p /workspace/build/cuda
RUN mkdir -p /workspace/build/nvtensorrt-sdk
RUN mkdir -p /workspace/build/nvcudnn-sdk
RUN mkdir -p /workspace/build/nvhpc-sdk
RUN mkdir -p /workspace/build/intelmkl-sdk

###
#
# Install NVIDIA CUDA SDK

ENV NVCUDA_INSTALL_DIR=/workspace/build/cuda
ENV NVTENSORRT_INSTALL_DIR=/workspace/build/nvtensorrt-sdk
ENV NVCUDNN_INSTALL_DIR=/workspace/build/nvcudnn-sdk
ENV NVHPC_INSTALL_DIR=/workspace/build/nvhpc-sdk
ENV INTELMKL_INSTALL_DIR=/workspace/build/intelmkl-sdk

ADD https://developer.download.nvidia.com/compute/cuda/12.2.1/local_installers/cuda_12.2.1_535.86.10_linux.run /workspace/added
RUN bash /workspace/added/cuda_12.2.1_535.86.10_linux.run --extract=/workspace/uncompressed/cuda_12.2.1_535
RUN for d in /workspace/uncompressed/cuda_12.2.1_535/cuda*; do cp -aR "${d}"/* ${NVCUDA_INSTALL_DIR}; done
RUN for d in /workspace/uncompressed/cuda_12.2.1_535/lib*; do cp -aR "${d}"/* ${NVCUDA_INSTALL_DIR}; done

###
#
# Install NVIDIA TensorRT
#
# https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt/secure/8.6.1/tars/TensorRT-8.6.1.6.Linux.x86_64-gnu.cuda-12.0.tar.gz

COPY TensorRT-8.6.1.6.Linux.x86_64-gnu.cuda-12.0.tar.gz /workspace/added
RUN tar -xf /workspace/added/TensorRT-8.6.1.6.Linux.x86_64-gnu.cuda-12.0.tar.gz --directory /workspace/uncompressed
RUN cp -aR /workspace/uncompressed/TensorRT-8.6.1.6/* ${NVTENSORRT_INSTALL_DIR}

###
#
# Install CUDNN:
#
# https://developer.nvidia.com/rdp/cudnn-download
# https://developer.nvidia.com/downloads/compute/cudnn/secure/8.9.4/local_installers/12.x/cudnn-linux-x86_64-8.9.4.25_cuda12-archive.tar.xz/
# https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html

COPY cudnn-linux-x86_64-8.9.4.25_cuda12-archive.tar.zst /workspace/added
RUN tar -xf /workspace/added/cudnn-linux-x86_64-8.9.4.25_cuda12-archive.tar.zst --directory /workspace/uncompressed
RUN cp -aR /workspace/uncompressed/cudnn-linux-x86_64-8.9.4.25_cuda12-archive/* ${NVCUDNN_INSTALL_DIR}

###
#
# Install NVIDIA HPC SDK

ADD https://developer.download.nvidia.com/hpc-sdk/23.7/nvhpc_2023_237_Linux_x86_64_cuda_12.2.tar.gz /workspace/added
RUN tar -xf /workspace/added/nvhpc_2023_237_Linux_x86_64_cuda_12.2.tar.gz --directory /workspace/uncompressed
RUN cp -aR /workspace/uncompressed/nvhpc_2023_237_Linux_x86_64_cuda_12.2/install_components/Linux_x86_64/23.7/* ${NVHPC_INSTALL_DIR}

###
#
# Install Intel MKL

COPY mkl-2023.1.0-h213fc3f_46343.tar.bz2 /workspace/added
COPY mkl-include-2023.1.0-h06a4308_46343.tar.bz2 /workspace/added
RUN tar -xf /workspace/added/mkl-2023.1.0-h213fc3f_46343.tar.bz2 --directory ${INTELMKL_INSTALL_DIR}
RUN tar -xf /workspace/added/mkl-include-2023.1.0-h06a4308_46343.tar.bz2 --directory ${INTELMKL_INSTALL_DIR}

FROM scratch
COPY --from=bookworm_nvidia /workspace/build /
