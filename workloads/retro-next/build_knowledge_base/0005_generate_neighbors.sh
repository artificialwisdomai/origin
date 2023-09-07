###
#
# Step 5. Generate neighbors
#
# outputs:
# $HOME/retro/data/index/chunks.neighbours.npy

python $HOME/repos/retro/src/data/retrieve_neighbours.py \
	--query-embeddings $HOME/repos/retro/data/index/chunks.embeddings.npy \
	--query-chunk2seq $HOME/repos/retro/data/index/chunk2seq.npy \
	--neighbours-output $HOME/repos/retro/data/index/chunks.neighbours.npy \ 
	--index $HOME/repos/retro/data/IVF131072,PQ32.index \
	--index-spec $HOME/repos/retro/data/index/index-spec.json \
	--num-neighbours 2 \
	--use-gpus \
	--shard-index
