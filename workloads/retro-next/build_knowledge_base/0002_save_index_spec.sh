###
#
# Step 3. Save index spec
#
# outputs:
# $HOME/retro/data/dataset-spec.json

cat << EOF > $HOME/retro/data/index-spec.json
[
    {
        "chunks": "chunks.npy",
        "seq2chunk": "seq2chunk.npy",
        "chunk2seq": "chunk2seq.npy",
        "embeddings": "chunks.embeddings.npy"
    }
]
EOF
