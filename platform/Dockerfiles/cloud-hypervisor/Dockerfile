# syntax=docker/dockerfile:1
FROM docker.io/library/debian:12 AS build_cloud_hypervisor
LABEL "com.computelify.vendor"="Computelify, Inc."
LABEL "cloud.artificialwisdom.vendor"="The Artificial Wisdom Cloud"
LABEL "version"="v1.80.0"
LABEL "description"="debian/cloud-hypervisor"

ENV DEBIAN_FRONTEND           noninteractive
ENV RUST_VERSION              1.80.0
ENV RUST_ARCH                 x86_64
ENV CLOUD_HYPERVISOR_VERSION  40.0

ENV PATH                      "$PATH:/root/.cargo/bin/"


###
#
# global build dependencies

RUN apt update
RUN apt --yes install curl
RUN apt --yes install git
RUN apt --yes install build-essential
RUN apt --yes install pkg-config
RUN apt --yes install musl-tools


###
#
# Runtime dependencies for cargo-deb

RUN apt --yes install dpkg
RUN apt --yes install dpkg-dev
RUN apt --yes install liblzma-dev


###
#
# Install rustup-init, which then installs the host toolchain, target toolchain, and cargo commands

WORKDIR /workspace/install
RUN curl --location --remote-name https://static.rust-lang.org/rustup/dist/${RUST_ARCH}-unknown-linux-gnu/rustup-init
RUN chmod +x rustup-init
RUN ./rustup-init -y --profile=minimal --default-host=${RUST_ARCH}-unknown-linux-gnu --default-toolchain=${RUST_VERSION}-${RUST_ARCH}-unknown-linux-gnu --target=${RUST_ARCH}-unknown-linux-musl
# 1-liner to list project features: cargo metadata --format-version=1 --no-deps | jq '.packages[].features | keys'
RUN cargo install cargo-deb --locked


###
#
# Prepare and build cloud-hypervisor

WORKDIR /workspace/build
RUN git clone --depth 1 --branch v${CLOUD_HYPERVISOR_VERSION} https://github.com/cloud-hypervisor/cloud-hypervisor cloud-hypervisor-v${CLOUD_HYPERVISOR_VERSION}

WORKDIR /workspace/build/cloud-hypervisor-v${CLOUD_HYPERVISOR_VERSION}
RUN cargo deb --profile release --target=${RUST_ARCH}-unknown-linux-musl --separate-debug-symbols --compress-debug-symbols


###
#
# Output the build by placing in ${PWD}/target

WORKDIR /workspace/target
RUN cp --archive --recursive /workspace/build/cloud-hypervisor-v${CLOUD_HYPERVISOR_VERSION}/target/${RUST_ARCH}-unknown-linux-musl/release/cloud-hypervisor /workspace/target/cloud-hypervisor_v${CLOUD_HYPERVISOR_VERSION}
RUN cp --archive --recursive /workspace/build/cloud-hypervisor-v${CLOUD_HYPERVISOR_VERSION}/target/${RUST_ARCH}-unknown-linux-musl/release/ch-remote /workspace/target/ch-remote_v${CLOUD_HYPERVISOR_VERSION}
RUN cp --archive --recursive /workspace/build/cloud-hypervisor-v${CLOUD_HYPERVISOR_VERSION}/target/${RUST_ARCH}-unknown-linux-musl/debian/cloud-hypervisor_${CLOUD_HYPERVISOR_VERSION}.0-1_amd64.deb /workspace/target

FROM scratch
COPY --from=build_cloud_hypervisor /workspace/target /
