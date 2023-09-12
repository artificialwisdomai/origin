FROM docker.io/library/debian:bookworm as bookworm_faiss

###
#
# https://github.com/artificialwisdomai/origin/wiki/Build-FAISS-from-source

ENV DEBIAN_FRONTEND  noninteractive
ENV FAISS_VERSION    1.7.4
ENV VENV_PATH        /workspace/v-faiss
ENV PYTHON_VENV      ${VENV_PATH}/bin/python
ENV PIP_VENV         ${VENV_PATH}/bin/pip
ENV PATH             ${PATH}:/workspace/v-faiss/bin:/usr/local/cuda/bin
ENV MKLROOT          /opt/intel/oneapi/mkl/2023.2.0
ENV MKLLIBS          ${MKLROOT}/lib/intel64

RUN apt update
RUN apt install -y build-essential
RUN apt install -y python3
RUN apt install -y python3-full
RUN apt install -y python3-venv
RUN apt install -y python3-pip
RUN apt install -y swig
RUN apt install -y ninja-build
RUN apt install -y git
RUN apt install -y cmake
RUN apt install -y gpg
RUN apt install -y ninja-build
RUN apt install -y curl

###
#
# NVIDIA CUDA-11.8's nvcc (parallel C compiler) does not integrate with gcc-12. For the moment
# use gcc-11. CUDA-12.2 is compatible, so using that for now. Using gcc-11 is quite a challenge
# https://github.com/facebookresearch/maskrcnn-benchmark/issues/25#issuecomment-433382510

#RUN apt install -y gcc-11
#RUN apt install -y g++-11
#RUN rm -f /usr/bin/gcc
#RUN rm -f /usr/bin/g++
#RUN ln -s /usr/bin/gcc-11 gcc
#RUN ln -s /usr/bin/g++-11 g++

WORKDIR /workspace
RUN mkdir -p /workspace/build/
RUN mkdir -p /workspace/target/

COPY debian.sources /etc/apt/sources.list.d/

###
#
# Provide CUDA via network for installation

RUN curl -sLO https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i /workspace/cuda-keyring_1.1-1_all.deb

###
#
# Provide Intel OneAPI MKL via network for installation
#
# https://www.intel.com/content/www/us/en/docs/oneapi/installation-guide-linux/2023-2/apt.html
# NB. we don't need the all of Intel's oneApi, we only need MKL.

RUN curl -sL https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | gpg --dearmor > /usr/share/keyrings/oneapi-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" > /etc/apt/sources.list.d/oneAPI.list

RUN apt update
RUN apt install -y cuda-toolkit-12-2
RUN apt install -y intel-oneapi-mkl
RUN apt install -y intel-oneapi-mkl-devel

RUN curl -sLO https://github.com/facebookresearch/faiss/archive/refs/tags/v1.7.4.tar.gz
RUN tar -xf v1.7.4.tar.gz

###
#
# Install faiss build depenendencies

RUN python3 -m venv ${VENV_PATH}
RUN ${PIP_VENV} install numpy
RUN ${PIP_VENV} install swig
RUN ${PIP_VENV} install wheel

WORKDIR /workspace/faiss-1.7.4/

#RUN ln -s /opt/intel/oneapi/mkl/latest /opt/intel/mkl

###
#
# This is needed to use the Ninja generator
# Unfortunately, I was not able to get the later make operations to work with ninja
#
#      -D CMAKE_ARGS:STRING="-d stats" \
#      -G Ninja \
#      -DCMAKE_INSTALL_LIBDIR=lib \

RUN cmake --fresh \
      -B _build \
      -D Python_EXECUTABLE=${PYTHON_VENV} \
      -D BUILD_SHARED_LIBS:BOOL=ON \
      -D BUILD_TESTING:BOOL=OFF \
      -D FAISS_OPT_LEVEL:STRING=avx2 \
      -D FAISS_ENABLE_C_API:BOOL=ON \
      -D FAISS_ENABLE_GPU:BOOL=ON \
      -D FAISS_ENABLE_RAFT:BOOL=OFF \
      -D FAISS_ENABLE_PYTHON:BOOL=ON \
      -D BLA_VENDOR:STRING=Intel10_64_dyn \
      -D MKL_LIBRARIES:PATH=${MKLLIBS} \
      -D CMAKE_INSTALL_PREFIX:PATH=/workspace/install \
      -D CMAKE_BUILD_TYPE:STRING=Release \
      -W no-dev \
      faiss-1.7.4

RUN make -j$(nproc) -C _build faiss
RUN make -j$(nproc) -C _build swigfaiss
RUN make -j$(nproc) -C _build swigfaiss_avx2
RUN make -j$(nproc) -C _build install

WORKDIR /workspace/faiss-1.7.4/_build/faiss/python
RUN ${PYTHON_VENV} setup.py bdist_wheel

###
#
# Output files to /workspace/target.
# These files are then copied to a new scratch.

WORKDIR /workspace/install
RUN echo "/opt/intel/oneapi/mkl/2023.2.0/lib/intel64" > /workspace/target/ld-so-conf-intel.conf
RUN tar -cf /workspace/target/intel-mkl-2023.2.0.tar.gz /opt/intel/oneapi/mkl/2023.2.0/lib/intel64
RUN tar -cf /workspace/target/faiss.tar.gz *
RUN cp -aR /workspace/faiss-1.7.4/_build/faiss/python/dist/*whl /workspace/target

FROM scratch
COPY --from=bookworm_faiss /workspace/target /
