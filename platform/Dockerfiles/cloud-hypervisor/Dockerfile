FROM docker.io/library/debian:bookworm as build_cloud_hypervisor

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
# https://doc.rust-lang.org/cargo/reference/unstable.html#list-of-unstable-features

WORKDIR /workspace/install
RUN curl -LO https://static.rust-lang.org/rustup/dist/${RUST_ARCH}-unknown-linux-gnu/rustup-init
RUN chmod +x rustup-init
RUN ./rustup-init -y --profile=minimal --default-host=${RUST_ARCH}-unknown-linux-gnu --default-toolchain=${RUST_VERSION}-${RUST_ARCH}-unknown-linux-gnu --target=${RUST_ARCH}-unknown-linux-musl
RUN cargo install cargo-feature --locked
RUN cargo install cargo-deb --locked


###
#
# Prepare and build cloud-hypervisor

WORKDIR /workspace/build
RUN git clone --depth 1 --branch v${CLOUD_HYPERVISOR_VERSION} https://github.com/cloud-hypervisor/cloud-hypervisor cloud-hypervisor-v${CLOUD_HYPERVISOR_VERSION}


###
#
# TODO(sdake): Define features
# https://doc.rust-lang.org/cargo/reference/features.html#the-features-section

WORKDIR /workspace/build/cloud-hypervisor-v${CLOUD_HYPERVISOR_VERSION}
RUN cargo deb --profile release --target=${RUST_ARCH}-unknown-linux-musl --separate-debug-symbols --compress-debug-symbols


###
#
# Output the build by copying the file to a new layer
# And then placed in ${PWD}/target

WORKDIR /workspace/target
RUN cp --archive --recursive /workspace/build/cloud-hypervisor-v${CLOUD_HYPERVISOR_VERSION}/target/${RUST_ARCH}-unknown-linux-musl/release/cloud-hypervisor /workspace/target/cloud-hypervisor_v${CLOUD_HYPERVISOR_VERSION}
RUN cp --archive --recursive /workspace/build/cloud-hypervisor-v${CLOUD_HYPERVISOR_VERSION}/target/${RUST_ARCH}-unknown-linux-musl/release/ch-remote /workspace/target/ch-remote_v${CLOUD_HYPERVISOR_VERSION}
RUN cp --archive --recursive /workspace/build/cloud-hypervisor-v${CLOUD_HYPERVISOR_VERSION}/target/${RUST_ARCH}-unknown-linux-musl/debian/cloud-hypervisor_${CLOUD_HYPERVISOR_VERSION}.0-1_amd64.deb /workspace/target

FROM scratch
COPY --from=build_cloud_hypervisor /workspace/target /
