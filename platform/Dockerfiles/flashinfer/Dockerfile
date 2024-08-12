ARG TOOLCHAIN_REVISION=undefined
FROM artificialwisdomai/toolchain:${TOOLCHAIN_REVISION} AS flashinfer

# syntax=docker/dockerfile:1
LABEL "com.computelify.vendor"="Computelify, Inc."
LABEL "cloud.artificialwisdom.vendor"="The Artificial Wisdom Cloud"
LABEL "version"="v0.1.4"
LABEL "description"="debian/flashinfer"

ENV FLASHINFER_VERSION="0.1.4"
ENV FLASHINFER_EPOCH="1"

WORKDIR /workspace
RUN git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/flashinfer-ai/flashinfer build

###
#
# Output the build by copying the file to a new layer
# And then placed in ${PWD}/target

WORKDIR /workspace/build/python
RUN "${PIP}" install torch
RUN "${PYTHON}" -m build --wheel --sdist --no-isolation
RUN cp --archive --recursive /workspace/build/python/dist/* /workspace/target


FROM scratch
COPY --from=flashinfer /workspace/target /
