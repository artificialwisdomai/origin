FROM docker.io/library/debian:bookworm as toolchain

ENV DEBIAN_FRONTEND           noninteractive
ENV RUST_VERSION              1.79.0
ENV RUST_ARCH                 x86_64

ENV PATH                      "$PATH:/root/.cargo/bin/"


###
#
# global build dependencies

RUN apt update
RUN apt -y install curl
RUN apt -y install git
RUN apt -y install apt-utils
RUN apt -y install build-essential
RUN apt -y install gperf
RUN apt -y install musl
RUN apt -y install musl-tools
RUN apt -y install musl-dev
RUN apt -y install bindgen
RUN apt -y install debhelper-compat
RUN apt -y install pkg-config
RUN apt -y install linux-libc-dev
RUN apt -y install autoconf
RUN apt -y install automake
RUN apt -y install libtool
RUN apt -y install m4
RUN apt -y install make

# Include lld linker to improve build times either by using environment variable
# possibly install clang lld


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

# wise@wise-a40x1-1:~/rustup$ rustup component list | grep musl | grep x86_64
# cargo-x86_64-unknown-linux-musl (installed)
# clippy-x86_64-unknown-linux-musl (installed)
# llvm-tools-x86_64-unknown-linux-musl
# rls-x86_64-unknown-linux-musl
# rust-analysis-x86_64-unknown-linux-musl
# rust-analyzer-x86_64-unknown-linux-musl
# rust-docs-x86_64-unknown-linux-musl (installed)
# rust-std-x86_64-unknown-linux-musl (installed)
# rustc-x86_64-unknown-linux-musl (installed)
# rustc-dev-x86_64-unknown-linux-musl
# rustfmt-x86_64-unknown-linux-musl (installed)
#--default-host=${RUST_ARCH}-unknown-linux-gnu --default-toolchain=${RUST_ARCH}-unknown-linux-musl
# wise@wise-a40x1-1:~/rustup$ rustup toolchain list 
# x86_64-unknown-linux-musl (installed)
# 1.74.0-x86_64-unknown-linux-musl (default)

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup-init.sh
RUN bash rustup-init.sh -y --default-host="${RUST_ARCH}-unknown-linux-gnu" --profile="default"
RUN rustup toolchain add "${RUST_VERSION}-${RUST_ARCH}-unknown-linux-gnu"
RUN rustup target add "${RUST_ARCH}-unknown-linux-musl"
#RUN rustup default "${RUST_VERSION}"


#RUN rustup-init.sh -y --profile=default --default-host=${RUST_ARCH}-unknown-linux-gnu --default-toolchain=${RUST_VERSION}-${RUST_ARCH}-unknown-linux-musl --target=${RUST_VERSION}-${RUST_ARCH}-unknown-linux-musl
#RUN rustup component add cargo-x86_64-unknown-linux-musl
#RUN rustup target add --toolchain <toolchain> <target>...
#RUN rustup target add --toolchain "${RUST_VERSION}-${RUST_ARCH}-unknown-linux-gnu" "${RUST_ARCH}-unknown-linux-musl"
#RUN rustup target add "${RUST_ARCH}-unknown-linux-musl"
#wise@wise-a40x1-1:~$ rustup target add --toolchain "${RUST_VERSION}-${RUST_ARCH}-unknown-linux-gnu" "${RUST_ARCH}-unknown-linux-musl"
# wise@wise-a40x1-1:~/rustup$ rustup target list | grep musl | grep x86_64


#RUN rustup component add clippy-x86_64-unknown-linux-musl
#RUN rustup component add rustfmt-x86_64-unknown-linux-musl
#RUN rustup component add rustc-dev-x86_64-unknown-linux-musl
#RUN rustup component add llvm-tools-dev-x86_64-unknown-linux-musl
#RUN rustup component add rls-dev-x86_64-unknown-linux-musl
#RUN rustup component add rust-std-x86_64-unknown-linux-musl
#RUN rustup component add rustc-x86_64-x86_64-unknown-linux-musl
#RUN rustup component add rustc-dev-x86_64-x86_64-unknown-linux-musl
#RUN rustup component add rustfmt-x86_64-x86_64-unknown-linux-musl


###
#
# Actually build virtiofsd from the rust image just prepared.

FROM toolchain as dependencies

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
RUN curl -LOs https://github.com/stevegrubb/libcap-ng/archive/refs/tags/v${LIBCAP_NG_VERSION}.tar.gz
RUN curl -LOs https://github.com/seccomp/libseccomp/archive/refs/tags/v${LIBSECCOMP_VERSION}.tar.gz

RUN tar -xf v${LIBCAP_NG_VERSION}.tar.gz
RUN tar -xf v${LIBSECCOMP_VERSION}.tar.gz


###
#
# Build libseccomp

WORKDIR /workspace/build/libseccomp-${LIBSECCOMP_VERSION}
RUN autoreconf --install --force --verbose --warning=all
RUN ./configure --enable-shared="no" --enable-static="yes" --enable-silent-rules="no" --prefix="/usr"
RUN make
RUN make install


###
#
# Build libcap-ng

WORKDIR /workspace/build/libcap-ng-${LIBCAP_NG_VERSION}
RUN touch NEWS
RUN autoreconf --install --force --verbose --warning=all
RUN ./configure --enable-shared="no" --enable-static="yes" --enable-silent-rules="no" --with-python="no" --with-python3="no" --with-capability_header="/usr/include/linux/capability.h" --prefix="/usr"
RUN make
RUN make install


###
#
# Prepare final application

FROM dependencies as application
ENV PATH                      "$PATH:/root/.cargo/bin/"
ENV RUST_VERSION              1.74.0
ENV RUST_ARCH                 x86_64
ENV VIRTIOFSD_VERSION         v1.10.1
ENV RUSTFLAGS                 "--codegen target-feature=+crt-static --codegen link-self-contained=yes"
ENV LIBSECCOMP_LINK_TYPE      "static"
ENV LIBSECCOMP_LIB_PATH       "/usr/lib"
ENV LIBCAPNG_LINK_TYPE        "static"
ENV LIBCAPNG_LIB_PATH         "/usr/lib"
# -- -D warnings -D clippy::undocumented_unsafe_blocks
# ENV RUSTFLAGS               "-D warnings -D clippy::undocumented_unsafe_blocks"
# ENV RUSTFLAGS               "-C link-arg=-fuse-ld=lld"
# or with Cargo's configuration file (i.e see .cargo/config.toml).

WORKDIR /workspace/build/
RUN curl -l https://gitlab.com/virtio-fs/virtiofsd/-/archive/${VIRTIOFSD_VERSION}/virtiofsd-${VIRTIOFSD_VERSION}.tar.gz --output virtiofsd-${VIRTIOFSD_VERSION}.tar.gz
RUN tar -xf virtiofsd-${VIRTIOFSD_VERSION}.tar.gz

WORKDIR /workspace/build/"virtiofsd-${VIRTIOFSD_VERSION}"
RUN cargo build --all-features --bins --future-incompat-report --locked --release --target x86_64-unknown-linux-musl

###
#
# Export final application to ${PWD}/target

WORKDIR /workspace/target
RUN cp -aR /workspace/build/virtiofsd-${VIRTIOFSD_VERSION}/target/${RUST_ARCH}-unknown-linux-musl/release/virtiofsd /workspace/target/virtiofsd_${VIRTIOFSD_VERSION}

FROM scratch
COPY --from=application /workspace/target /


###
#
# TODO(sdake): Define features
# https://doc.rust-lang.org/cargo/reference/features.html#the-features-section
# TODO: cargo-copy-cult
#        cflags="-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1 -O2"
#        ./configure --prefix="${libseccomp_install_dir}" CFLAGS="${cflags}" --enable-static
# TODO: cargo deb will build a debian package for us
# Although I wish to maintain the capability to have multiple hypervisor versions
# on the same filesystem at the same time.
#
###

# These may be important
# https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/199/diffs
# https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/16/diffs
# https://gitlab.com/virtio-fs/virtiofsd/-/issues/118
# https://gitlab.com/virtio-fs/virtiofsd/-/issues/84
# https://gitlab.com/virtio-fs/virtiofsd/-/issues/134
# [Awesome refresher covering autotools](https://www.lrde.epita.fr/~adl/dl/autotools.pdf)
# https://doc.rust-lang.org/rustc/linker-plugin-lto.html
# https://github.com/rust-cuda/wg/blob/master/documents/roadmap.md https://github.com/japaric-archived/nvptx#targets https://llvm.org/docs/LinkTimeOptimization.html
# https://doc.rust-lang.org/cargo/reference/profiles.html#profile-settings
# Environment: https://doc.rust-lang.org/cargo/reference/environment-variables.html
# https://doc.rust-lang.org/cargo/reference/config.html#configuration-format
# https://doc.rust-lang.org/cargo/reference/environment-variables.html
# https://doc.rust-lang.org/cargo/commands/cargo-vendor.html
# https://github.com/cloud-hypervisor/cloud-hypervisor/pull/5941
# https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/24593.pdf
