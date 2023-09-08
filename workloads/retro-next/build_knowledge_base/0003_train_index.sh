###
#
# Step 4. Train a faiss index
#
# outputs:
# ${INDEX_PATH}/IVF131072,PQ32.index

python ${SRC_HOME}/train_faiss_index.py \
        --spec ${INDEX_PATH}/index-spec.json \
        --max-training-vectors 33554432 \
        --index-type IVF131072,PQ32 \
        --output ${INDEX_PATH}/IVF131072,PQ32.index \
        --use-gpus
