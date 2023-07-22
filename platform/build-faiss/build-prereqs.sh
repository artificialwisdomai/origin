#!/bin/bash

set -e
export PATH=$HOME/.local/bin:$PATH
export DEBIAN_FRONTEND=noninteractive

cat <<EOF | sudo tee /etc/apt/sources.list.d/debian-contrib.list
deb http://http.us.debian.org/debian bullseye contrib
deb-src http://http.us.debian.org/debian bullseye contrib
deb http://security.debian.org/debian-security bullseye-security contrib
deb-src http://security.debian.org/debian-security bullseye-security contrib
deb http://http.us.debian.org/debian bullseye-updates contrib
deb-src http://http.us.debian.org/debian bullseye-updates contrib
EOF

sudo -E apt-get update && sudo -E apt-get dist-upgrade -y

# Install python and build essentials and essential libraries
sudo -E apt-get install -y python3-venv python3-pip python3-venv python3-wheel python3-dev build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev liblzma-dev libsqlite3-dev libreadline-dev libbz2-dev neovim curl git wget

# Add a couple Python prerequisites
sudo pip install -U pip setuptools wheel numpy swig torch

# Get Intel OneAPI for BLAS support
wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
| gpg --dearmor | sudo -E tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo -E tee /etc/apt/sources.list.d/oneAPI.list

# ensure we're using the latest cmake
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo -E tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | sudo -E tee /etc/apt/sources.list.d/kitware.list >/dev/null

# add the cuda tools to build against
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo -E dpkg -i cuda-keyring_1.1-1_all.deb

# Update and install MKL, Cmake, and Cuda-toolkit
sudo -E apt-get update
sudo -E apt install intel-oneapi-mkl cmake cuda-11-8 -y

#Verify python and pytorch work

python3 -c 'import torch; print(f"Is CUDA Available: {torch.cuda.is_available()}")'

