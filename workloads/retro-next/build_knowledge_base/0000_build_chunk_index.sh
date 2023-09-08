####
#
# Step 0. Tokenize dataset and create a mapping
#
# outputs:
# ${INDEX_PATH}/chunks.npy: tokenized dataset
# ${INDEX_PATH}/seq2chunk.npy: maps sequence to chunk
# ${INDEX_PATH}/chunk2seq.npy: maps chunk to sequence

cat ${DATASET_PATH} | python ${SRC_PATH}/tokenize_and_chunk.py \
    --chunks-out ${INDEX_PATH}/chunks.npy \
    --seq2chunk-index-out ${INDEX_PATH}/seq2chunk.npy \
    --chunk2seq-index-out ${INDEX_PATH}/chunk2seq.npy \
    --chunk-size 64 \
    --max-chunks 300000 \
   --verbose
