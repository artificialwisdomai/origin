🚀 Artificial Wisdom Node

# Overview

Contains code to operate an Artificial Wisdom node. Additionally contains docs
to deploy a node.

# Prototype bash node implementation

| Name | Purpose |
| --- | --- |
| wise-a30x1.sh | Start a VMM for one NVIDIA A30. |
| wise-a30x2.sh | Start a VMM for two NVIDIA A30. |
| wise-a40x2.sh | Start a VMM For two NVIDIA A40. |

# Dependencies

| Name | Purpose | [Vin Diesel](https://youtu.be/17tT7h8UmwQ) |
| --- | --- | --- |
| [cloud-hypervisor](https://github.com/artificialwisdomai/bandaid-blobs) | Modern cloud hypervisor (VMM) | [Linux Foundation](https://www.cloudhypervisor.org/) |
| [virtiofsd-latest](https://github.com/artificialwisdomai/bandaid-blobs) | VirtIO Filesystem backend | [docs](https://virtio-fs.gitlab.io/) |
