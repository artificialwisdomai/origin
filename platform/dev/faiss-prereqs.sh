#!/bin/bash

# Get Python 3.10 and create a pyenv virtualenv and set it as local
pyenv install 3.10
pyenv virtualenv 3.10 aw
pyenv local aw

# Add a couple Python prerequisites
pip install -U pip setuptools wheel
pip install numpy swig

export DEBIAN_FRONTEND=noninteractive

# Get CUDA and install it
sudo -E curl -Lo /tmp/cuda-keyring_1.1-1_all.deb https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.1-1_all.deb
sudo -E apt install /tmp/cuda-keyring_1.1-1_all.deb

sudo -E apt update
sudo -E apt install cuda -y
sudo -E apt install cuda-toolkit -y

# Get Intel OneAPI for BLAS support
# From: https://www.intel.com/content/www/us/en/docs/oneapi/installation-guide-linux/2023-0/apt.html

# download the key to system keyring
wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
| gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null

# add signed entry to apt sources and configure the APT client to use Intel repository:
echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list


sudo -E apt update
sudo -E apt install intel-basekit -y
#sudo -E apt install nvidia-cuda-toolkit -y

# ensure we're using the latest cmake
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null

echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null

sudo -E apt-get update
sudo -E apt-get install cmake -y

