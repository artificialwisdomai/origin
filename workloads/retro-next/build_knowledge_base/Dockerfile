FROM debian:bookworm

ENV VENV_PATH /workspace/venv
ENV INDEX_PATH /workspace/target/index
ENV DATASET_PATH /workspace/dataset
ENV SRC_PATH /workspace/src

ENV python_venv /workspace/venv/bin/python
ENV pip_venv /workspace/venv/bin/pip

RUN apt -y update
RUN apt -y upgrade
RUN apt -y install python3
RUN apt -y install python3-pip
RUN apt -y install python3-venv

RUN python3 -m venv ${VENV_PATH}

RUN ${pip_venv} install numpy
RUN ${pip_venv} install transformers
RUN ${pip_venv} install sentence_transformers

RUN mkdir -p ${VENV_PATH}
RUN mkdir -p ${INDEX_PATH}
RUN mkdir -p ${DATASET_PATH}
RUN mkdir -p ${SRC_PATH}

WORKDIR /workspace

COPY 0000_build_chunk_index.sh ${SRC_PATH}
COPY 0001_precompute_emdeddings.sh ${SRC_PATH}
COPY 0002_save_index_spec.sh ${SRC_PATH}
COPY 0003_train_index.sh ${SRC_PATH}
COPY 0004_build_index.sh ${SRC_PATH}
COPY 0005_generate_neighbors.sh ${SRC_PATH}
