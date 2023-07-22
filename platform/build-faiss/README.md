# Set up an Ubuntu 22.04 machine to build FAISS

## Setup for build in Ubuntu 22.04 with podman

Add podman

```sh
sudo apt install podman -y
```

Run build in podman:

```sh
podman run --rm -it -v ${PWD}/dev/origin/:/origin ubuntu:22.04 /bin/bash /origin/build.sh
```

This should produce two files:

* python*.whl

  a python wheel for faiss deployment

* faiss-libs.tgz

  a set of libraries for FAISS.  Note Intel libraries are still required as well.

## Setup for Ubuntu 22.04 bare metal in OCI
Assumptions:

/dev/nvme0n1 exists and can be reformatted
NVIDIA GPU installed

## base setup

Add python prerequisites
Mount /dev/nvme0n1 on /models
Link .cache and .local from ubuntu to /models

```sh
bash add_dev.sh
```

## Build prerequisites

Add Nvidia and Intel OneAPK libraries needed to build FAISS

```sh
bash faiss-prereqs.sh
```

## Build FAISS

Download the git repository and build it!

```sh
bash build-faiss.sh
``` 
