#! Set up an Ubuntu 22.04 machine to build FAISS

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
