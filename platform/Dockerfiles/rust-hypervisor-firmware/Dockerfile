# syntax=docker/dockerfile:1
FROM docker.io/library/debian:12 AS build_rust_hypervisor_firmware
LABEL "com.computelify.vendor"="Computelify, Inc."
LABEL "cloud.artificialwisdom.vendor"="The Artificial Wisdom Cloud"
LABEL "version"="v0.4.2"
LABEL "description"="debian/rust_hypervisor_firmware"


ENV DEBIAN_FRONTEND="noninteractive"
ENV RUST_HYPERVISOR_FIRMWARE_VERSION="0.4.2"
ENV RUST_HYPERVISOR_FIRMWARE_EPOCH="1"
ENV PATH="$PATH:/root/.cargo/bin/"
ENV RUST_VERSION="v1.80.0"
ENV RUST_ARCH="x86_64"


###
#
# global build dependencies

RUN apt update
RUN apt -y install curl
RUN apt -y install git
RUN apt -y install build-essential
RUN apt -y install pkg-config


###
#
# Runtime dependencies for cargo-deb

RUN apt -y install dpkg
RUN apt -y install dpkg-dev
RUN apt -y install liblzma-dev


###
#
# Prepare and build rust-hypervisor-firmware

WORKDIR /workspace/build
RUN git clone --depth 1 -b ${RUST_HYPERVISOR_FIRMWARE_VERSION} https://github.com/cloud-hypervisor/rust-hypervisor-firmware rust-hypervisor-firmware-${RUST_HYPERVISOR_FIRMWARE_VERSION}


###
#
# Install rustup-init, which then installs the host toolchain, target toolchain, and cargo commands
# https://doc.rust-lang.org/cargo/reference/unstable.html#list-of-unstable-features

WORKDIR /workspace/install
RUN curl --location --remote-name https://static.rust-lang.org/rustup/dist/${RUST_ARCH}-unknown-linux-gnu/rustup-init
RUN chmod +x rustup-init
RUN ./rustup-init -y --profile minimal --default-host ${RUST_ARCH}-unknown-linux-gnu --default-toolchain stable --target ${RUST_ARCH}-unknown-none
RUN cargo install cargo-deb --locked

#RUN rustup component add rust-std
#RUN rustup component add rust-src



#RUN rustup default nightly
#RUN rustup component add rust-src --toolchain nightly


###
#
# Build rust-hypervisor-firmware

WORKDIR /workspace/build/rust-hypervisor-firmware-${RUST_HYPERVISOR_FIRMWARE_VERSION}
#RUN rustup target add ${RUST_ARCH}-unknown-none
RUN cargo build --release --target ${RUST_ARCH}-unknown-none.json -Z build-std=core,alloc -Z build-std-features=compiler-builtins-mem
RUN ls -lR /workspace/build/rust-hypervisor-firmware-0.4.2/
RUN cargo deb --no-build --no-strip --target ${RUST_ARCH}-unknown-none
RUN find / -name \*deb -ls


###
#
# Output the build by copying the file to a new layer
# And then placed in ${PWD}/target

WORKDIR /workspace/target
RUN cp --archive --recursive /workspace/build/rust-hypervisor-firmware-${RUST_HYPERVISOR_FIRMWARE_VERSION}/target/${RUST_ARCH}-unknown-none/release /workspace/target/
RUN cp --archive --recursive /workspace/build/rust-hypervisor-firmware-${RUST_HYPERVISOR_FIRMWARE_VERSION}/target/${RUST_ARCH}-unknown-none/debian/hypervisor-fw_${RUST_HYPERVISOR_FIRMWARE_VERSION}-${RUST_HYPERVISOR_FIRMWARE_EPOCH}_amd64.deb /workspace/target


FROM scratch
COPY --from=build_rust_hypervisor_firmware /workspace/target /
