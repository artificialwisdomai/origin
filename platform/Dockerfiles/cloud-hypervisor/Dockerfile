FROM docker.io/library/debian:bookworm as build_cloud_hypervisor

ENV DEBIAN_FRONTEND           noninteractive
ENV RUST_VERSION              1.78.0
ENV RUST_ARCH                 x86_64
ENV CLOUD_HYPERVISOR_VERSION  v39.0

ENV PATH                      "$PATH:/root/.cargo/bin/"


###
#
# global build dependencies

RUN apt update
RUN apt -y install curl
RUN apt -y install git
RUN apt -y install build-essential
RUN apt -y install pkg-config
RUN apt -y install musl-tools


###
#
# Runtime dependencies for cargo-deb

RUN apt -y install dpkg
RUN apt -y install dpkg-dev
RUN apt -y install liblzma-dev


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
RUN git clone --filter=tree:0 -b ${CLOUD_HYPERVISOR_VERSION} https://github.com/cloud-hypervisor/cloud-hypervisor cloud-hypervisor-${CLOUD_HYPERVISOR_VERSION}


###
#
# TODO(sdake): Define features
# https://doc.rust-lang.org/cargo/reference/features.html#the-features-section

WORKDIR /workspace/build/cloud-hypervisor-${CLOUD_HYPERVISOR_VERSION}
RUN cargo rustc --release --locked --bin="cloud-hypervisor" --no-default-features --features="kvm,io_uring"  --target="${RUST_ARCH}-unknown-linux-musl" --future-incompat-report -- -D warnings -D clippy::undocumented_unsafe_blocks

###
#
# Output the build by copying the file to a new layer
# And then placed in ${PWD}/target

WORKDIR /workspace/target
RUN cp -aR /workspace/build/cloud-hypervisor-${CLOUD_HYPERVISOR_VERSION}/target/${RUST_ARCH}-unknown-linux-musl/release/cloud-hypervisor /workspace/target/cloud_hypervisor_${CLOUD_HYPERVISOR_VERSION}

FROM scratch
COPY --from=build_cloud_hypervisor /workspace/target /

# TODO: cargo deb will build a debian package for us
# Although I wish to maintain the capability to have multiple hypervisor versions
# on the same filesystem at the same time.
#
###


# These may be important to follow up with, or they may be uninteresting.
#
# https://doc.rust-lang.org/rustc/linker-plugin-lto.html
# https://github.com/rust-cuda/wg/blob/master/documents/roadmap.md
# https://github.com/japaric-archived/nvptx#targets
# https://llvm.org/docs/LinkTimeOptimization.html
# https://doc.rust-lang.org/cargo/reference/profiles.html#profile-settings
# Environment: https://doc.rust-lang.org/cargo/reference/environment-variables.html
# https://doc.rust-lang.org/cargo/reference/config.html#configuration-format
# https://doc.rust-lang.org/cargo/reference/environment-variables.html
# https://doc.rust-lang.org/cargo/commands/cargo-vendor.html
# https://github.com/cloud-hypervisor/cloud-hypervisor/pull/5941
# https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/24593.pdf
