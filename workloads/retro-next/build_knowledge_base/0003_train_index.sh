###
#
# Step 4. Train a faiss index
#
# outputs:
# $HOME/retro/data/IVF131072,PQ32.index

python $HOME/repos/retro/src/data/train_faiss_index.py \
        --spec $HOME/repos/retro/data/index/index-spec.json \
        --max-training-vectors 33554432 \
        --index-type IVF131072,PQ32 \
        --output $HOME/repos/retro/data/IVF131072,PQ32.index \
        --use-gpus
