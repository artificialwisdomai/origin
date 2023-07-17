FROM docker.io/library/debian:12

ENV DEBIAN_FRONTEND=noninteractive

# Phase 1: Install free components.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3-dev python3-numpy-dev swig python3-virtualenv \
        cmake git gpg default-jre

# Phase 2: Install non-free components.

# Configure Intel repo and non-free/contrib Debian repos.
ADD debian.sources oneAPI.list /etc/apt/sources.list.d/

# Set up build directory.
WORKDIR /build

# Add nVidia CUDA repo and keyring.
ADD https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.1-1_all.deb /build/
RUN dpkg -i cuda-keyring_1.1-1_all.deb

# Add Intel keyring.
ADD https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB /build/
RUN < GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB gpg --dearmor > /usr/share/keyrings/oneapi-archive-keyring.gpg

# Do a big install.
RUN apt-get update && \
    apt-get install -y --no-install-recommends cuda intel-basekit

# Phase 3: Prepare the build tree with CMake.
ADD https://github.com/facebookresearch/faiss/archive/refs/tags/v1.7.4.tar.gz /build/
# XXX For whatever reason, Podman *doesn't* automatically unpack the source
# tarball. This is fine, but at odds with Docker's behavior.
RUN tar zxf v1.7.4.tar.gz

RUN virtualenv /build/local

ENV CUDACXX=/usr/local/cuda/bin/nvcc
COPY run-cmake.sh /build
RUN sh run-cmake.sh

# Phase 4: Invoke compilers.
RUN make -C build -j2 faiss swigfaiss
RUN cd build/faiss/python && \
    /build/local/bin/python setup.py bdist_wheel && \
    cd /build
