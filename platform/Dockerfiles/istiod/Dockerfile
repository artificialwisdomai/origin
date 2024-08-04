FROM docker.io/library/debian:bookworm AS build_istiod

ENV DEBIAN_FRONTEND="noninteractive"
ENV ISTIOD_VERSION="1.22.3"
ENV PATH="$PATH:/usr/local/go/bin"
ENV TARGET_ARCH="amd64"
ENV DEB_COMPRESSION="--deb-compression=none"
# postinst.sh may not be needed.
ENV SIDECAR_FILES="pilot-discovery istioctl envoy pilot-agent envoy_bootstrap.json istio-start.sh istio.service sidecar.env postinst.sh"
ENV BUILD_WITH_CONTAINER="0"
ENV GO_VERSION="1.22.5"


RUN apt update
RUN apt --yes install build-essential
RUN apt --yes install curl
RUN apt --yes install ruby3.1
RUN apt --yes install git

RUN gem3.1 install fpm

RUN mkdir -p /workspace/source
RUN mkdir -p /workspace/build
RUN mkdir -p /workspace/target

WORKDIR /workspace/fetch
RUN curl --location https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz --remote-name
RUN tar -xf go${GO_VERSION}.linux-amd64.tar.gz
RUN mv go /usr/local

###
#
# Prepare and build cloud-hypervisor

WORKDIR /workspace/source
RUN git clone --depth 1 --branch ${ISTIOD_VERSION} https://github.com/istio/istio istiod-${ISTIOD_VERSION}

WORKDIR /workspace/source/istiod-${ISTIOD_VERSION}
RUN make build-linux
RUN make deb

RUN cp --archive --recursive /workspace/source/istiod-${ISTIOD_VERSION}/out/linux_amd64/* /workspace/target

FROM scratch
COPY --from=build_istiod /workspace/target /
