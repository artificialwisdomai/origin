###
#
# step 1. precompute embeddings for all chunks
#
# outputs:
# ${INDEX_PATH}/chunks.embeddings.npy
# ${INDEX_PATH}/chunks.npy

python ${SRC_PATH}/embed_chunks.py \
	${INDEX_PATH}/chunks.npy \
	${INDEX_PATH}/chunks.embeddings.npy
