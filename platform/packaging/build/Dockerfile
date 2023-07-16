FROM docker.io/library/debian:12

ENV DEBIAN_FRONTEND=noninteractive

# Phase 1: Install free components.
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    python3-dev python3-numpy-dev swig python3-virtualenv \
    cmake git gpg wget

# Phase 2: Install non-free components.
RUN sed -i -e 's/main/main contrib non-free/g' /etc/apt/sources.list.d/debian.sources

# Add nVidia CUDA repository.
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb

# Add Intel repository.
RUN wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
  | gpg --dearmor | tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" \
  >> /etc/apt/sources.list.d/oneAPI.list

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    cuda intel-basekit

# Phase 3: Prepare the build tree with CMake.
RUN mkdir /build
WORKDIR /build

RUN virtualenv /build/local

RUN wget https://github.com/facebookresearch/faiss/archive/refs/tags/v1.7.4.tar.gz
RUN tar zxvf v1.7.4.tar.gz > /dev/null

ENV CUDACXX=/usr/local/cuda/bin/nvcc
COPY run-cmake.sh /build
RUN sh run-cmake.sh

# Phase 4: Invoke compilers.
RUN make -C build -j2 faiss swigfaiss
RUN cd build/faiss/python && \
    /build/local/bin/python setup.py bdist_wheel && \
    cd /build
