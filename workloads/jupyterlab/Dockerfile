FROM docker.io/library/debian:bookworm

LABEL maintainer="Artificial Wisdom Cloud <hello@artificialwisdom.cloud>"

ENV SHELL=/bin/bash

###
#
# Cargo Copy Cult from:
# /docker-stacks/images/docker-stacks-foundation

ENV                      JUPYTERLAB_USER=jupyterlab
ENV                      LC_ALL=en_US.UTF-8
ENV                      LANG=en_US.UTF-8
ENV                      LANGUAGE=en_US.UTF-8

###
#
# Cargo Copy Cult is off now

ENV DEBIAN_FRONTEND      noninteractive
ENV JUPYTERLAB_VERSION   v4.0.0
ENV VENV_PATH            /workspace/v-jupyterlab
ENV PYTHON_VENV          ${VENV_PATH}/bin/python
ENV PIP_VENV             ${VENV_PATH}/bin/pip
ENV CUDA_VERSION         12.2.2
ENV ZSTD_CLEVEL          18
ENV ZSTD_NBTHREADS       16

ENV PATH                 ${PATH}:${VENV_PATH}/bin

###
#
# TODO(sdake): SECURITY

USER root

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
RUN apt install -y curl
RUN apt install -y zstd
RUN apt install -y bash
RUN apt install -y fonts-firacode

###
#
# Cargo copy Cult on

RUN apt install -y bzip2
RUN apt install -y ca-certificates
RUN apt install -y locales
RUN apt install -y sudo
RUN apt install -y tini
RUN apt install -y wget
RUN apt install -y fonts-liberation
RUN apt install -y fonts-dejavu
RUN apt install -y pandoc
RUN apt install -y nodejs

### Cult failure
#RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
#RUN local-gen

###
#
# Cargo copy cult off
#
# TODO(sdake): --shell should be bash, but that fails.
# --shell sh
# --create-home
# ${JUPYTERLAB_USER}

RUN useradd --no-create-home --system --user-group --groups sudo jupyterlab

WORKDIR /workspace
RUN mkdir -p /workspace/build/
RUN mkdir -p /workspace/target/

###
#
# These next two blocks, pytorch install and m package install, may not be needed.
# They *were* needed when I was installing this stuff manually.

###
#
# General ML packages

#RUN ${PIP_VENV} install torch
#RUN ${PIP_VENV} install torchvision
#RUN ${PIP_VENV} install torchaudio
#RUN ${PIP_VENV} install transformers
#RUN ${PIP_VENV} install transformers_stream_generator
#RUN ${PIP_VENV} install einops
#RUN ${PIP_VENV} install tiktoken
#RUN ${PIP_VENV} install accelerate

###
#
# Jupyterlab including aethetics

RUN python3 -m venv ${VENV_PATH}
RUN ${PIP_VENV} install jupyterlab
RUN ${PIP_VENV} install jupyterlab-fonts
RUN ${PIP_VENV} install cognite_jupyterlab_theme
RUN ${PIP_VENV} install jupyterlab_midnightsea_theme

###
#
# Language servers

RUN ${PIP_VENV} install jupyterlab-lsp==5.0.0
RUN ${PIP_VENV} install jedi-language-server

###
#
# These language servers look interesting, more study is needed.
#RUN npm install --save-dev bash-language-server
#RUN npm install --save-dev dockerfile-language-server-nodejs
#RUN npm install --save-dev pyright
#RUN npm install --save-dev sql-language-server
#RUN npm install --save-dev typescript-language-server
#RUN npm install --save-dev unified-language-server
#RUN npm install --save-dev vscode-css-languageserver-bin
#RUN npm install --save-dev vscode-json-languageserver-bin

###
#
# Various third-party extensions
# Worth a read. https://github.com/jupyterlab/extension-examples

RUN ${PIP_VENV} install dask-labextension
RUN ${PIP_VENV} install jupyterlab_pygments
RUN ${PIP_VENV} install jupyterlab-github


WORKDIR /workspace/target/
WORKDIR /workspace/v-jupyterlab/
WORKDIR /workspace/jupyterlab/
