###
#
# step 1. precompute embeddings for all chunks
#
# outputs:
# $HOME/retro/data/index/chunks.embeddings.npy

python $HOME/repos/retro/src/data/embed_chunks.py \
	$HOME/repos/retro/data/index/chunks.npy \
	$HOME/repos/retro/data/index/chunks.embeddings.npy
