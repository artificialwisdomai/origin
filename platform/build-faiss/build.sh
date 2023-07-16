#!/bin/bash

if [ -d /origin ]; then
  cd /origin/platform/build-faiss
else
  echo "artificialwisdomai/origin project needs to exist"
  exit 1
fi

if [[ ! `id -u` -eq 0 ]]; then
  echo "This needs to run as root"
  exit 1
fi

export PATH=$HOME/.local/bin:$PATH
export DEBIAN_FRONTEND=noninteractive

apt-get update && apt-get dist-upgrade -y

# Install python and build essentials and essential libraries
apt-get install -y python3-venv python3-pip python3-dev build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev liblzma-dev libsqlite3-dev libreadline-dev libbz2-dev neovim curl git wget

# Update Setuptools
python3 -m pip install -U pip setuptools wheel

# Add a couple Python prerequisites
pip install numpy swig torch

# Get Intel OneAPI for BLAS support
# From: https://www.intel.com/content/www/us/en/docs/oneapi/installation-guide-linux/2023-0/apt.html

# download the key to system keyring
wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
| gpg --dearmor | tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null

# add signed entry to apt sources and configure the APT client to use Intel repository:
echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list

apt update
apt install dkms intel-basekit -y

## Get CUDA and install it

curl -sLO https://developer.download.nvidia.com/compute/cuda/12.2.0/local_installers/cuda_12.2.0_535.54.03_linux.run
bash $PWD/cuda_*run --silent --toolkit --driver --no-man-page

# ensure we're using the latest cmake
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - |  tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null

echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' |  tee /etc/apt/sources.list.d/kitware.list >/dev/null

# add the cuda tools to build against

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
apt-get update
apt-get install cmake cuda-toolkit -y

#Verify python and pytorch work

python3 -c 'import torch; print(f"Is CUDA Available: {torch.cuda.is_available()}")'

git clone https://github.com/facebookresearch/faiss
cd faiss

# Configure paths and set environment variables
export PATH=$PATH:$HOME/.local/bin:/usr/local/cuda/bin
source /opt/intel/oneapi/setvars.sh

# Configure using cmake

LD_LIBRARY_PATH=/usr/local/lib MKLROOT=/opt/intel/oneapi/mkl/2023.2.0/ CXX=g++-11 cmake -B build \
	-DBUILD_SHARED_LIBS=ON \
	-DBUILD_TESTING=ON \
	-DFAISS_ENABLE_GPU=ON \
	-DFAISS_OPT_LEVEL=avx2 \
	-DFAISS_ENABLE_C_API=ON \
	-DFAISS_ENABLE_PYTHON=ON \
	-DCMAKE_BUILD_TYPE=Release \
	-DFAISS_ENABLE_RAFT=OFF \
	-DBLA_VENDOR=Intel10_64_dyn -Wno-dev .

# Now build faiss

make -C build -j$(nproc) faiss
make -C build -j$(nproc) swigfaiss
pushd build/faiss/python;python3 setup.py bdist_wheel;popd

# and install it. NOTE: this will install into the pyenv virtualenv 'aw' from the begining of the script

make -C build -j$(nproc) install
#pip install --force-reinstall build/faiss/python/dist/faiss-1.7.4-py3-none-any.whl
cp build/faiss/python/dist/faiss-1.7.4-py3-none-any.whl ../

# add libraries to /usr/local/lib
mkdir -p ../faiss-libs

for n in build/faiss/python/*so build/faiss/*so
  do
    cp $n ../faiss-libs/
  done
tar cfz ../faiss-libs.tgz ../faiss-libs/*
rm -rf ../faiss-libs

cd ..
#rm -rf faiss
