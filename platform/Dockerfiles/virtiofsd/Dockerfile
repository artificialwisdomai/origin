ARG TOOLCHAIN_REVISION=undefined
FROM artificialwisdomai/toolchain:${TOOLCHAIN_REVISION} AS virtiofsd

# syntax=docker/dockerfile:1
LABEL "com.computelify.vendor"="Computelify, Inc."
LABEL "cloud.artificialwisdom.vendor"="The Artificial Wisdom Cloud"
LABEL "version"="v1.11.1"
LABEL "description"="debian/virtiofsd"


ENV VIRTIOFSD_VERSION="1.11.1"
ENV LIBCAP_NG_VERSION="0.8.5"
ENV LIBSECCOMP_VERSION="2.5.5"

ENV CC="musl-gcc"
ENV CPPFLAGS="-isystem /usr/include/x86_64-linux-musl/ -isystem /usr/include/x86_64-linux-gnu/ -isystem /usr/include"
ENV RUSTFLAGS="--codegen target-feature=+crt-static --codegen link-self-contained=yes"


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
COPY --from=virtiofsd /workspace/target /
