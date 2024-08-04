# syntax=docker/dockerfile:1
FROM docker.io/library/debian:12 AS build_linux_kernel
LABEL "com.computelify.vendor"="Computelify, Inc."
LABEL "cloud.artificialwisdom.vendor"="The Artificial Wisdom Cloud"
LABEL "version"="6.1.99"
LABEL "epoch"="0"
LABEL "description"="debian/linux-kernel"

###
#
# Define environment

WORKDIR /workspace
RUN mkdir -p /workspace/build
RUN mkdir -p /workspace/tmp
RUN mkdir -p /workspace/added
RUN mkdir -p /workspace/uncompressed
RUN mkdir -p /workspace/target
RUN mkdir -p /workspace/patches


###
#
# Set global environment variables

ENV LINUX_KERNEL_VERSION="6.1.99"
ENV LINUX_KERNEL_EPOCH="0"
ENV DEBIAN_FRONTEND="noninteractive"


###
#
# Install toolchain and system dependencies

RUN apt --yes update
RUN apt --yes install build-essential
RUN apt --yes install ca-certificates
RUN apt --yes install linux-source
RUN apt --yes install bc
RUN apt --yes install kmod
RUN apt --yes install cpio
RUN apt --yes install flex
RUN apt --yes install libncurses5-dev
RUN apt --yes install libelf-dev
RUN apt --yes install libssl-dev
RUN apt --yes install dwarves
RUN apt --yes install bison
RUN apt --yes install python3

RUN apt --yes install ninja-build
RUN apt --yes install git
RUN apt --yes install cmake
RUN apt --yes install gpg
RUN apt --yes install zstd
RUN apt --yes install tar


###
#
# Setup build environment and clone pytorch

ENV BUILD_DEFCONFIG="/usr/src/linux-kernel.config"
RUN tar --directory /usr/src --extract --file /usr/src/linux-source-6.1.tar.xz
WORKDIR /usr/src/linux-source-6.1
COPY config-${LINUX_KERNEL_VERSION} .config
RUN make olddefconfig
RUN make -j`nproc` bindeb-pkg

RUN cp -aR /usr/src/*deb /workspace/target


###
#
# Produce a clean image of build results for output from buildx

FROM scratch
COPY --from=build_linux_kernel /workspace/target /
