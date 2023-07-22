#!/bin/bash

git clone https://github.com/istio/istio.io.git /tmp/istio/
mv /tmp/istio/content/en ./en

rm -rf chunks *json
mkdir -p ./chunks

if [ -d .venv ]; then
  source .venv/bin/activate
else
  python3 -m venv .venv
  source .venv/bin/activate
  pip install -U pip wheel -r requirements.txt
  pip install ../platform/build-faiss/faiss-1.7.4-py3-none-any.whl
fi

python3 train.py
