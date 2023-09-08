###
#
# Step 5. Generate neighbors
#
# outputs:
# ${INDEX_PATH}/chunks.neighbours.npy

python ${SRC_PATH}/retrieve_neighbours.py \
	--query-embeddings ${INDEX_PATH}/chunks.embeddings.npy \
	--query-chunk2seq ${INDEX_PATH}/chunk2seq.npy \
	--neighbours-output ${INDEX_PATH}/chunks.neighbours.npy \
	--index ${INDEX_PATH}/IVF131072,PQ32.index \
	--index-spec ${INDEX_PATH}/index-spec.json \
	--num-neighbours 2 \
	--use-gpus \
	--shard-index
