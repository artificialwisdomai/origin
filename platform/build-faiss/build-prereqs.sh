#!/bin/bash

set -e
export PATH=$HOME/.local/bin:$PATH
export DEBIAN_FRONTEND=noninteractive

sudo -E apt-get update && sudo -E apt-get dist-upgrade -y

# Install python and build essentials and essential libraries
sudo -E apt-get install -y python3-venv python3-pip python3-dev build-essential libssl-dev libffi-dev lib
xml2-dev libxslt1-dev liblzma-dev libsqlite3-dev libreadline-dev libbz2-dev neovim curl git wget



# Add a couple Python prerequisites
pip install -U pip setuptools wheel
pip install numpy swig torch

export DEBIAN_FRONTEND=noninteractive

# Get Intel OneAPI for BLAS support
# From: https://www.intel.com/content/www/us/en/docs/oneapi/installation-guide-linux/2023-0/apt.html

# download the key to system keyring
wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
| gpg --dearmor | sudo -E tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null

# add signed entry to apt sources and configure the APT client to use Intel repository:
echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo -E tee /etc/apt/sources.list.d/oneAPI.list


sudo -E apt update
sudo -E apt install dkms intel-basekit -y

## Get CUDA and install it

curl -sLO https://developer.download.nvidia.com/compute/cuda/12.2.0/local_installers/cuda_12.2.0_535.54.03_linux.run
sudo -E bash $PWD/cuda_*run --silent --toolkit --driver --no-man-page

# ensure we're using the latest cmake
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo -E tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null

echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | sudo -E tee /etc/apt/sources.list.d/kitware.list >/dev/null

# add the cuda tools to build against

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo -E dpkg -i cuda-keyring_1.1-1_all.deb
sudo -E apt-get update
sudo -E apt-get install cmake cuda-toolkit -y

#Verify python and pytorch work

python3 -c 'import torch; print(f"Is CUDA Available: {torch.cuda.is_available()}")'

