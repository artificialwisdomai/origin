# syntax=docker/dockerfile:1
FROM docker.io/library/debian:12 AS toolchain
LABEL "com.computelify.vendor"="Computelify, Inc."
LABEL "cloud.artificialwisdom.vendor"="The Artificial Wisdom Cloud"
LABEL "version"="v1.11.1"
LABEL "description"="debian/virtiofsd"


ENV VIRTIOFSD_VERSION="1.11.1"
ENV DEBIAN_FRONTEND="noninteractive"
ENV RUST_VERSION="1.80.0"
ENV RUST_ARCH="x86_64"

ENV PATH="$PATH:/root/.cargo/bin/"


###
#
# global build dependencies

RUN apt update
RUN apt --yes install curl
RUN apt --yes install git
RUN apt --yes install apt-utils
RUN apt --yes install build-essential
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


###
#
# Runtime dependencies for cargo-deb

RUN apt --yes install dpkg
RUN apt --yes install dpkg-dev
RUN apt --yes install liblzma-dev


###
#
# Install rustup-init, which then installs the host toolchain, target toolchain, and cargo commands
# https://doc.rust-lang.org/cargo/reference/unstable.html#list-of-unstable-features

WORKDIR /workspace/install
RUN curl --location --remote-name https://static.rust-lang.org/rustup/dist/${RUST_ARCH}-unknown-linux-gnu/rustup-init
RUN chmod +x rustup-init
RUN ./rustup-init -y --profile=minimal --default-host=${RUST_ARCH}-unknown-linux-gnu --default-toolchain=${RUST_VERSION}-${RUST_ARCH}-unknown-linux-gnu --target=${RUST_ARCH}-unknown-linux-musl
RUN cargo install cargo-deb --locked


###
#
# Actually build virtiofsd from the rust image just prepared.

FROM toolchain AS dependencies

ENV DEBIAN_FRONTEND           noninteractive
ENV LIBCAP_NG_VERSION         0.8.5
ENV LIBSECCOMP_VERSION        2.5.5
ENV PATH                      "$PATH:/root/.cargo/bin/"

ENV CC                        "musl-gcc"
ENV CPPFLAGS                  "-isystem /usr/include/x86_64-linux-musl/ -isystem /usr/include/x86_64-linux-gnu/ -isystem /usr/include"


###
#
# Prepare and build system dependencies

WORKDIR /workspace/build/
RUN git clone --depth 1 --branch v${LIBCAP_NG_VERSION} https://github.com/stevegrubb/libcap-ng libcap-ng-v${LIBCAP_NG_VERSION}
RUN git clone --depth 1 --branch v${LIBSECCOMP_VERSION} https://github.com/seccomp/libseccomp libseccomp-v${LIBSECCOMP_VERSION}


###
#
# Build libseccomp

WORKDIR /workspace/build/libseccomp-v${LIBSECCOMP_VERSION}
RUN bash autogen.sh
RUN ./configure --enable-shared="no" --enable-static="yes" --enable-silent-rules="no" --prefix="/usr"
RUN make
RUN make install


###
#
# Build libcap-ng

WORKDIR /workspace/build/libcap-ng-v${LIBCAP_NG_VERSION}
RUN bash autogen.sh
RUN ./configure --enable-shared="no" --enable-static="yes" --enable-silent-rules="no" --with-python3="no" --with-capability_header="/usr/include/linux/capability.h" --prefix="/usr"
RUN make
RUN make install


###
#
# Prepare final application

FROM dependencies AS build_virtiofsd
ENV PATH="$PATH:/root/.cargo/bin/"
ENV RUST_VERSION="1.80.0"
ENV RUST_ARCH="x86_64"
ENV VIRTIOFSD_VERSION="1.11.1"
ENV RUSTFLAGS="--codegen target-feature=+crt-static --codegen link-self-contained=yes"
ENV LIBSECCOMP_LINK_TYPE="static"
ENV LIBSECCOMP_LIB_PATH="/usr/lib"
ENV LIBCAPNG_LINK_TYPE="static"
ENV LIBCAPNG_LIB_PATH="/usr/lib"


###
#
# Build virtiofsd binary and debian package

WORKDIR /workspace/build/
RUN git clone --depth 1 --branch v${VIRTIOFSD_VERSION} https://gitlab.com/virtio-fs/virtiofsd virtiofsd-v${VIRTIOFSD_VERSION}

WORKDIR /workspace/build/virtiofsd-v${VIRTIOFSD_VERSION}
RUN cargo build --release --target=${RUST_ARCH}-unknown-linux-musl --all-targets
RUN cargo deb --no-build --separate-debug-symbols --compress-debug-symbols --target=${RUST_ARCH}-unknown-linux-musl


###
#
# Export final application to ${PWD}/target

WORKDIR /workspace/target
RUN cp --archive --recursive /workspace/build/virtiofsd-v${VIRTIOFSD_VERSION}/target/${RUST_ARCH}-unknown-linux-musl/release/virtiofsd /workspace/target/virtiofsd_v${VIRTIOFSD_VERSION}
RUN cp --archive --recursive /workspace/build/virtiofsd-v${VIRTIOFSD_VERSION}/target/${RUST_ARCH}-unknown-linux-musl/debian/virtiofsd_${VIRTIOFSD_VERSION}-1_amd64.deb /workspace/target


FROM scratch
COPY --from=build_virtiofsd /workspace/target /
