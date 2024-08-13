FROM debian:bookworm AS baseline

###
#
# Define environment

WORKDIR /workspace


###
#
# Set global environment variables

ENV MKL_VERSION="2024.2"
ENV CUDA_VERSION="12-6"
ENV RUST_VERSION="1.80.0"
ENV GO_VERSION="1.22.5"
ENV RUST_ARCH="x86_64"
ENV TARGET_ARCH="amd64"
ENV DEB_COMPRESSION="--deb-compression=none"
ENV BUILD_WITH_CONTAINER="0"

ENV PATH="$PATH:/usr/local/cuda/bin:/root/.cargo/bin:/usr/local/go/bin:/workspace/v/bin"
ENV DEBIAN_FRONTEND="noninteractive"
ENV VENV_PATH="/workspace/v"
ENV PYTHON="${VENV_PATH}/bin/python"
ENV PIP="${VENV_PATH}/bin/pip"
ENV LIBSECCOMP_LINK_TYPE="static"
ENV LIBSECCOMP_LIB_PATH="/usr/lib"
ENV LIBCAPNG_LINK_TYPE="static"
ENV LIBCAPNG_LIB_PATH="/usr/lib"


###
#
# Create default paths

RUN mkdir -p /workspace/source
RUN mkdir -p /workspace/build
RUN mkdir -p /workspace/target
RUN mkdir -p /workspace/install


###
#
# Install toolchain and system dependencies

RUN apt update
RUN apt --yes install build-essential
RUN apt --yes install ca-certificates
RUN apt --yes install python3-minimal
RUN apt --yes install python3-venv
RUN apt --yes install python3-pip
RUN apt --yes install python3-pip
RUN apt --yes install git
RUN apt --yes install gpg
RUN apt --yes install curl
RUN apt --yes install pkg-config
RUN apt --yes install zstd
RUN apt --yes install dpkg
RUN apt --yes install dpkg-dev
RUN apt --yes install liblzma-dev
RUN apt --yes install libnuma-dev
RUN apt --yes install libssl-dev
RUN apt --yes install libzstd-dev
RUN apt --yes install libucx-dev
RUN apt --yes install libmpfr-dev
RUN apt --yes install libgmp3-dev
RUN apt --yes install libfftw3-dev
RUN apt --yes install libjpeg-dev
RUN apt --yes install libpng-dev
RUN apt --yes install dpkg-dev
RUN apt --yes install liblzma-dev
RUN apt --yes install apt-utils
RUN apt --yes install gperf
RUN apt --yes install musl
RUN apt --yes install musl-tools
RUN apt --yes install musl-dev
RUN apt --yes install bindgen
RUN apt --yes install debhelper-compat
RUN apt --yes install pkg-config
RUN apt --yes install linux-libc-dev
RUN apt --yes install autoconf
RUN apt --yes install automake
RUN apt --yes install libtool
RUN apt --yes install m4
RUN apt --yes install make
RUN apt --yes install dpkg


###
#
# Install NVIDIA CUDA SDK

RUN curl -LO https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb
RUN apt-get update
RUN apt -y install software-properties-common
RUN add-apt-repository contrib
RUN apt-get update
RUN apt -y install cuda-toolkit-${CUDA_VERSION}
RUN apt -y install libcusparselt-dev
RUN apt -y install cudnn


###
#
# Install Intel MKL BLAS

RUN curl --location "https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB" --remote-name
RUN gpg --dearmor -o /usr/share/keyrings/oneapi-archive-keyring.gpg GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
RUN echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" > /etc/apt/sources.list.d/oneAPI.list

RUN apt update
RUN apt install -y intel-oneapi-mkl
RUN apt install -y intel-oneapi-mkl-devel


###
#
# Install Rust toolchain

WORKDIR /workspace/install
RUN curl --location --remote-name https://static.rust-lang.org/rustup/dist/${RUST_ARCH}-unknown-linux-gnu/rustup-init
RUN chmod +x rustup-init
RUN ./rustup-init -y --profile=minimal --default-host=${RUST_ARCH}-unknown-linux-gnu --default-toolchain=${RUST_VERSION}-${RUST_ARCH}-unknown-linux-gnu --target=${RUST_ARCH}-unknown-linux-musl
RUN cargo install cargo-deb --locked


###
#
# Install Go toolchain

RUN curl --location --remote-name https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
RUN tar -xf go${GO_VERSION}.linux-amd64.tar.gz
RUN mv go /usr/local

###
#
# Install Python build virtual environmnet

RUN python3 -m venv ${VENV_PATH}
RUN ${PIP} install build
RUN ${PIP} install wheel
RUN ${PIP} install cmake
RUN ${PIP} install packaging
RUN ${PIP} install ninja
RUN ${PIP} install swig
