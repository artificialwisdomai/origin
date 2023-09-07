####
#
# Step 0. Tokenize dataset and create a mapping
#
# outputs:
# $HOME/repos/retro/data/index/seq2chunk.npy
# $HOME/repos/retro/data/index/chunk2seq.npy
cat data/datasets/RealNews/train_realnews.jsonl | python src/data/tokenize_and_chunk.py \
    --chunks-out $HOME/repos/retro/data/index/chunks.npy \
    --seq2chunk-index-out $HOME/repos/retro/data/index/seq2chunk.npy \
    --chunk2seq-index-out $HOME/repos/retro/data/index/chunk2seq.npy \
    --chunk-size 64 \
    --max-chunks 300000 \
   --verbose
