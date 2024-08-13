ARG TOOLCHAIN_REVISION=undefined
FROM artificialwisdomai/toolchain:${TOOLCHAIN_REVISION} AS istiod

ENV ISTIOD_VERSION="1.22.3"
ENV SIDECAR_FILES="pilot-discovery istioctl envoy pilot-agent envoy_bootstrap.json istio-start.sh istio.service sidecar.env postinst.sh"


###
#
# Install fpm which is required by Istio's makefiles

RUN apt --yes install ruby3.1
RUN gem3.1 install fpm

###
#
# Prepare and build istiod

WORKDIR /workspace
RUN git clone --depth 1 --branch ${ISTIOD_VERSION} https://github.com/istio/istio build

WORKDIR /workspace/build
RUN make build-linux
RUN make deb

RUN cp --archive --recursive /workspace/build/out/linux_amd64/release/*.deb /workspace/target

FROM scratch
COPY --from=istiod /workspace/target /
