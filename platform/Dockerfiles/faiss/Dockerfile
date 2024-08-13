ARG TOOLCHAIN_REVISION="undefined"
FROM artificialwisdomai/toolchain:${TOOLCHAIN_REVISION} AS faiss

# syntax=docker/dockerfile:1
LABEL "com.computelify.vendor"="Computelify, Inc."
LABEL "cloud.artificialwisdom.vendor"="The Artificial Wisdom Cloud"
LABEL "version"="v1.8.0"
LABEL "description"="debian/faiss"

ENV FAISS_EPOCH="1"
ENV FAISS_VERSION="1.8.0"

RUN apt update
RUN apt install --yes build-essential
RUN apt install --yes python3
RUN apt install --yes python3-full
RUN apt install --yes python3-venv
RUN apt install --yes python3-pip
RUN apt install --yes swig
RUN apt install --yes ninja-build
RUN apt install --yes git
RUN apt install --yes cmake
RUN apt install --yes gpg
RUN apt install --yes curl
RUN apt install --yes zstd
RUN apt install --yes gpg-agent
RUN apt install --yes wget
RUN apt install --yes dpkg-dev
RUN apt install --yes fakeroot
RUN apt install --yes devscripts
RUN apt install --yes debhelper

###
#
# Copy our patches for application

COPY debian.sources /etc/apt/sources.list.d/
RUN mkdir -p /workspace/patches
COPY faiss-v${FAISS_VERSION}-introduce-epoch.patch /workspace/patches/
COPY faiss-v${FAISS_VERSION}-runpath-origin.patch /workspace/patches/
COPY faiss-v${FAISS_VERSION}-setuppy-include-binaries.patch /workspace/patches/


###
#
# Retrieve the faiss branch and patch it so that it will link properly

WORKDIR "/workspace"
RUN git clone --depth 1 --branch v${FAISS_VERSION} https://github.com/facebookresearch/faiss.git build
WORKDIR "/workspace/build"
RUN patch --strip=1 --directory="/workspace/build" --input="/workspace/patches/faiss-v${FAISS_VERSION}-introduce-epoch.patch"
RUN patch --strip=1 --directory="/workspace/build" --input="/workspace/patches/faiss-v${FAISS_VERSION}-runpath-origin.patch"
RUN patch --strip=1 --directory="/workspace/build" --input="/workspace/patches/faiss-v${FAISS_VERSION}-setuppy-include-binaries.patch"


RUN ${PIP} install numpy

###
#
# This is needed to use the Ninja generator
# Unfortunately, I was unable to get the later make operations to work with ninja
#
#      -D CMAKE_ENVS:STRING="-d stats" \
#      -G Ninja \
#      -DCMAKE_INSTALL_LIBDIR=lib \

###
#
# Configure the faiss build using cmake

RUN cmake --fresh \
      -S /workspace/build \
      -B /workspace/build \
      -D Python_EXECUTABLE:STRING=${PYTHON} \
      -D BUILD_SHARED_LIBS:BOOL=ON \
      -D BLA_STATIC:BOOL=ON \
      -D BUILD_TESTING:BOOL=OFF \
      -D FAISS_OPT_LEVEL:STRING=avx2 \
      -D FAISS_ENABLE_C_API:BOOL=ON \
      -D FAISS_ENABLE_GPU:BOOL=ON \
      -D FAISS_ENABLE_RAFT:BOOL=OFF \
      -D FAISS_ENABLE_PYTHON:BOOL=ON \
      -D BLA_VENDOR:STRING=Intel10_64ilp \
      -D BLA_STATIC:BOOL=True \
      -D MKL_LIBRARIES:STRING=${MKL_LIBRARIES} \
      -D CMAKE_INSTALL_PREFIX:PATH=/opt/meta/faiss \
      -D CMAKE_BUILD_TYPE:STRING=Release \
      -D FAISS_EPOCH:STRING=${FAISS_EPOCH} \
      -D CMAKE_CUDA_ARCHITECTURES:STRING="80;86;89;90" \
      -W no-dev


###
#
# Build faiss, swigfaiss, swigfaiss_avx2, and then install the python callback
# Next, build a faiss wheel from the compiled source.

WORKDIR "/workspace/build"
RUN make --jobs=$(nproc) --directory="/workspace/build" faiss
RUN make --jobs=$(nproc) --directory="/workspace/build" swigfaiss
RUN make --jobs=$(nproc) --directory="/workspace/build" swigfaiss_avx2
RUN make --jobs=$(nproc) --directory="/workspace/build" install

WORKDIR "/workspace/build/faiss/python"
RUN "${PYTHON}" -m build --wheel --sdist --no-isolation

RUN cp --archive "/workspace/build/faiss/python/dist/faiss-${FAISS_VERSION}+${FAISS_EPOCH}-py3-none-any.whl" --target-directory="/workspace/target/"


###
#
# Output file layers that contain the files /workspace/target are then copied into a new
# scratch bookworm_faiss to build the final results from the build image.
#
# And then placed in ${PWD}/target

FROM scratch
COPY --from=faiss /workspace/target /
