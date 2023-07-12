#!/bin/bash

git clone https://github.com/facebookresearch/faiss
cd faiss

# Configure paths and set environment variables
export PATH=$PATH:$HOME/.local/bin:/usr/local/cuda/bin
source /opt/intel/oneapi/setvars.sh

#export CC=gcc-12
#export CXX=g++-12
# Configure using cmake

LD_LIBRARY_PATH=/usr/local/lib MKLROOT=/opt/intel/oneapi/mkl/2023.1.0/ CXX=g++-11 cmake -B build \
	-DBUILD_SHARED_LIBS=ON \
	-DBUILD_TESTING=ON \
	-DFAISS_ENABLE_GPU=ON \
	-DFAISS_OPT_LEVEL=axv2 \
	-DFAISS_ENABLE_C_API=ON \
	-DCMAKE_BUILD_TYPE=Release \
	-DBLA_VENDOR=Intel10_64_dyn -Wno-dev .
#cmake -B build . \
        -DBUILD_SHARED_LIBS=ON \
	-DFAISS_ENABLE_GPU=ON \
	-DFAISS_ENABLE_PYTHON=ON \
	-DFAISS_ENABLE_RAFT=OFF \
	-DBUILD_TESTING=ON \
	-DBUILD_SHARED_LIBS=ON \
	-DFAISS_ENABLE_C_API=ON \
	-DCMAKE_BUILD_TYPE=Release \
	-DFAISS_OPT_LEVEL=avx2 -Wno-dev

# Now build faiss

make -C build -j$(nproc) faiss
make -C build -j$(nproc) swigfaiss
pushd build/faiss/python;python3 setup.py bdist_wheel;popd

# and install it. NOTE: this will install into the pyenv virtualenv 'aw' from the begining of the script

sudo -E make -C build -j$(nproc) install
pip install --force-reinstall build/faiss/python/dist/faiss-1.7.4-py3-none-any.whl
cp build/faiss/python/dist/faiss-1.7.4-py3-none-any.whl ../

# add libraries to /usr/local/lib
mkdir -p faiss-libs

for n in build/faiss/python/*so build/faiss/*so
  do
    sudo cp $n /usr/local/lib/
    cp $n faiss-libs/
  done
tar cfz ../faiss-libs.tgz faiss-libs/*
rm -rf faiss-libs

# Add ldconfig settings for intel and faiss libraries

echo '/opt/intel/oneapi/mkl/2023.1.0/lib/intel64' | sudo tee /etc/ld.so.conf.d/aw_intel.conf
echo '/usr/local/lib' | sudo tee /etc/ld.so.conf.d/aw_faiss.conf

# Update the ld cache

sudo -E ldconfig

cd ..
rm -rf faiss
