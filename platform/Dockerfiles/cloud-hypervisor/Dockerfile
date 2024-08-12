ARG TOOLCHAIN_REVISION=undefined
FROM artificialwisdomai/toolchain:${TOOLCHAIN_REVISION} AS build_cloud_hypervisor

# syntax=docker/dockerfile:1
LABEL "com.computelify.vendor"="Computelify, Inc."
LABEL "cloud.artificialwisdom.vendor"="The Artificial Wisdom Cloud"
LABEL "version"="v40.0"
LABEL "description"="debian/cloud-hypervisor"

ENV CLOUD_HYPERVISOR_VERSION="40.0"

WORKDIR /workspace
RUN git clone --depth 1 --branch v${CLOUD_HYPERVISOR_VERSION} https://github.com/cloud-hypervisor/cloud-hypervisor build

WORKDIR /workspace/build/
RUN cargo deb --profile release --target=${RUST_ARCH}-unknown-linux-musl --separate-debug-symbols --compress-debug-symbols

RUN cp --archive --recursive /workspace/build/target/${RUST_ARCH}-unknown-linux-musl/release/cloud-hypervisor /workspace/target/cloud-hypervisor_v${CLOUD_HYPERVISOR_VERSION}
RUN cp --archive --recursive /workspace/build/target/${RUST_ARCH}-unknown-linux-musl/release/ch-remote /workspace/target/ch-remote_v${CLOUD_HYPERVISOR_VERSION}
RUN cp --archive --recursive /workspace/build/target/${RUST_ARCH}-unknown-linux-musl/debian/cloud-hypervisor_${CLOUD_HYPERVISOR_VERSION}.0-1_amd64.deb /workspace/target

FROM scratch
COPY --from=build_cloud_hypervisor /workspace/target /
