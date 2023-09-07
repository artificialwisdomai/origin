###
#
# Step 4. Build a faiss index
#
# outputs:
# $HOME/retro/data/data.index

python $HOME/repos/retro/src/data/build_faiss_index.py \
        --spec $HOME/repos/retro/data/index/index-spec.json \
	--trained-index $HOME/repos/retro/data/IVF131072,PQ32.index \
	--output-index $HOME/repos/retro/data/data.index \
	--use-gpus \
	--shard-index
