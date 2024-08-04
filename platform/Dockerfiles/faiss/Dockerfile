# syntax=docker/dockerfile:1
FROM docker.io/library/debian:12 AS build_faiss
LABEL "com.computelify.vendor"="Computelify, Inc."
LABEL "cloud.artificialwisdom.vendor"="The Artificial Wisdom Cloud"
LABEL "version"="v1.8.0"
LABEL "description"="debian/faiss"


###
#
# Our build environment variables
# Learn more: https://github.com/artificialwisdomai/origin/wiki/Build-FAISS-from-source

ENV DEBIAN_VERSION="12"
ENV FAISS_EPOCH="1"
ENV DEBIAN_FRONTEND="noninteractive"
ENV FAISS_VERSION="1.8.0"
ENV VENV_PATH="/workspace/v"
ENV PYTHON_VENV="${VENV_PATH}/bin/python"
ENV PIP_VENV="${VENV_PATH}/bin/pip"
ENV MKL_VERSION="2024.2"
ENV PATH="${PATH}:/workspace/v/bin:/usr/local/cuda/bin"
ENV MKL_ROOT="/opt/intel/oneapi/mkl/${MKL_VERSION}/lib/"
ENV CUDA_VERSION="12.6.0"
ENV ZSTD_CLEVEL="18"
ENV ZSTD_NBTHREADS="16"
ENV MKL_ROOT="/opt/intel/oneapi/mkl/${MKL_VERSION}/lib/intel64"
ENV MKL_MODEL="ilp64"
ENV MKL_LIBRARIES="-Wl,--start-group;${MKL_ROOT}/libmkl_intel_${MKL_MODEL}.a;${MKL_ROOT}/libmkl_gnu_thread.a;${MKL_ROOT}/libmkl_core.a;-Wl,--end-group"
ENV CUDA_ARCHS="80;86;89;90"


###
#
# install essential build dependencies

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
# Generate workspace directory tree

WORKDIR /workspace/source/
RUN mkdir -p /workspace/source/faiss-v${FAISS_VERSION}/
RUN mkdir -p /workspace/build/faiss-v${FAISS_VERSION}/
RUN mkdir -p /workspace/target/
RUN mkdir -p /workspace/patches/


###
#
# Copy our patches for application

COPY debian.sources /etc/apt/sources.list.d/
COPY faiss-v${FAISS_VERSION}-introduce-epoch.patch /workspace/patches/
COPY faiss-v${FAISS_VERSION}-runpath-origin.patch /workspace/patches/
COPY faiss-v${FAISS_VERSION}-setuppy-include-binaries.patch /workspace/patches/


###
#
# Provide CUDA via network for installation

RUN curl --location "https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb" --output "/workspace/source/cuda-keyring_1.1-1_all.deb"
RUN dpkg --install "/workspace/source/cuda-keyring_1.1-1_all.deb"


###
#
# Provide Intel OneAPI MKL via network for installation
#
# https://www.intel.com/content/www/us/en/docs/oneapi/installation-guide-linux/${MKL_VERSION}/apt.html

RUN curl --location --remote-name https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
RUN gpg --dearmor --output /usr/share/keyrings/oneapi-archive-keyring.gpg /workspace/source/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
RUN echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" > /etc/apt/sources.list.d/oneAPI.list


###
#
# Add complex third party dependencies

RUN apt update
RUN apt install -y cuda-toolkit-12-6
RUN apt install -y intel-oneapi-mkl
RUN apt install -y intel-oneapi-mkl-devel


###
#
# Install faiss python build depenendencies

RUN python3 -m venv ${VENV_PATH}
RUN ${PIP_VENV} install numpy
RUN ${PIP_VENV} install swig
RUN ${PIP_VENV} install build
RUN ${PIP_VENV} install wheel

###
#
# Retrieve the faiss tarball and patch it so that it will link properly

RUN git clone --depth 1 --branch v${FAISS_VERSION} https://github.com/facebookresearch/faiss.git /workspace/source/faiss-v${FAISS_VERSION}
RUN patch --strip=1 --directory="/workspace/source/faiss-v${FAISS_VERSION}" --input="/workspace/patches/faiss-v${FAISS_VERSION}-introduce-epoch.patch"
RUN patch --strip=1 --directory="/workspace/source/faiss-v${FAISS_VERSION}" --input="/workspace/patches/faiss-v${FAISS_VERSION}-runpath-origin.patch"
RUN patch --strip=1 --directory="/workspace/source/faiss-v${FAISS_VERSION}" --input="/workspace/patches/faiss-v${FAISS_VERSION}-setuppy-include-binaries.patch"


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
      -S /workspace/source/faiss-v${FAISS_VERSION} \
      -B /workspace/build/faiss-v${FAISS_VERSION} \
      -D Python_EXECUTABLE:STRING=${PYTHON_VENV} \
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
      -D CMAKE_CUDA_ARCHITECTURES:STRING=${CUDA_ARCHS} \
      -W no-dev


###
#
# Build faiss, swigfaiss, swigfaiss_avx2, and then install the python callback
# Next, build a faiss wheel from the compiled source.

WORKDIR "/workspace/build/faiss-v${FAISS_VERSION}"
RUN make --jobs=$(nproc) --directory="/workspace/build/faiss-v${FAISS_VERSION}" faiss
RUN make --jobs=$(nproc) --directory="/workspace/build/faiss-v${FAISS_VERSION}" swigfaiss
RUN make --jobs=$(nproc) --directory="/workspace/build/faiss-v${FAISS_VERSION}" swigfaiss_avx2
RUN make --jobs=$(nproc) --directory="/workspace/build/faiss-v${FAISS_VERSION}" install

WORKDIR "/workspace/build/faiss-v${FAISS_VERSION}/faiss/python"
RUN "${PYTHON_VENV}" -m build --wheel --sdist --no-isolation


###
#
# Link statically, although storing /opt/intel for later consumption is a good idea.

RUN echo "/opt/intel/oneapi/mkl/${MKL_VERSION}.0/lib/intel64" > /workspace/target/ld-so-conf-intel-mkl.conf
RUN tar --use-compress-program=zstd --absolute-names -cf /workspace/target/intel-oneapi-${MKL_VERSION}.0.tar.zst /opt/intel/oneapi

###
#
# Generate artifacts from build
#
# - /workspace/target:
#   - faiss-v1.8.0.tar.zst
#   - ld-so-conf-meta-faiss.conf
#   - faiss-v1.8.0-py3-none-any.whl
#
# - /workspace/target
#   - intel-mkl-2024.2.0.tar.zst
#   - ld-so-conf-intel-mkl.conf

WORKDIR /workspace/target
RUN echo "/opt/meta/faiss/lib" > /workspace/target/intel-mkl-${MKL_VERSION}_ld.so.conf
RUN tar --use-compress-program=zstd --absolute-names --create --file /workspace/target/intel-oneapi-${MKL_VERSION}.tar.zst /opt/intel/oneapi
RUN tar --use-compress-program=zstd --absolute-names --create --file "/workspace/target/faiss-v${FAISS_VERSION}+${FAISS_EPOCH}.tar.zst" /opt/meta/faiss
RUN cp --archive "/workspace/build/faiss-v${FAISS_VERSION}/faiss/python/dist/faiss-${FAISS_VERSION}+${FAISS_EPOCH}-py3-none-any.whl" --target-directory="/workspace/target/"


###
#
# Output file layers that contain the files /workspace/target are then copied into a new
# scratch bookworm_faiss to build the final results from the build image.
#
# And then placed in ${PWD}/target

FROM scratch
COPY --from=build_faiss /workspace/target /
