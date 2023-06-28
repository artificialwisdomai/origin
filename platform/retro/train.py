import torch
from retro_pytorch import RETRO, TrainingWrapper

# instantiate RETRO, fit it into the TrainingWrapper with correct settings

retro = RETRO(
    max_seq_len = 2048,                      # max sequence length
    enc_dim = 896,                           # encoder model dimension
    enc_depth = 3,                           # encoder depth
    dec_dim = 768,                           # decoder model dimensions
    dec_depth = 12,                          # decoder depth
    dec_cross_attn_layers = (1, 3, 6, 9),    # decoder cross attention layers (with causal chunk cross attention)
    heads = 8,                               # attention heads
    dim_head = 64,                           # dimension per head
    dec_attn_dropout = 0.25,                 # decoder attention dropout
    dec_ff_dropout = 0.25                    # decoder feedforward dropout
).cuda()

wrapper = TrainingWrapper(
    retro = retro,                                 # path to retro instance
    knn = 2,                                       # knn (2 in paper was sufficient)
    chunk_size = 64,                               # chunk size (64 in paper)
    documents_path = './text_folder',              # path to folder of text
    glob = '**/*.txt',                             # text glob
    chunks_memmap_path = './train.chunks.dat',     # path to chunks
    seqs_memmap_path = './train.seq.dat',          # path to sequence data
    doc_ids_memmap_path = './train.doc_ids.dat',   # path to document ids per chunk (used for filtering neighbors belonging to same document)
    max_chunks = 1_000_000,                        # maximum cap to chunks
    max_seqs = 1_000,                            # maximum seqs
    knn_extra_neighbors = 100,                     # num extra neighbors to fetch
    max_index_memory_usage = '10m',
    current_memory_available = '10G'
)
print("finished training wrapper")

# get the dataloader and optimizer (AdamW with all the correct settings)

train_dl = iter(wrapper.get_dataloader(batch_size = 2, shuffle = True))
optim = wrapper.get_optimizer(lr = 3e-4, wd = 0.01)

# now do your training
# ex. one gradient step

seq, retrieved = map(lambda t: t.cuda(), next(train_dl))
print(f"seq:{seq}\n retrieved:{retrieved}")

# seq       - (2, 2049)         - 1 extra token since split by seq[:, :-1], seq[:, 1:]
# retrieved - (2, 32, 2, 128)   - 128 since chunk + continuation, each 64 tokens

loss = retro(
    seq,
    retrieved,
    return_loss = True
)
print(f"loss:{loss}")
# one gradient step

loss.backward()
optim.step()
optim.zero_grad()

# do above for many steps, then ...

# topk sampling with retrieval at chunk boundaries

sampled = wrapper.generate(filter_thres = 0.9, temperature = 1.0) # (1, <2049) terminates early if all <eos>

# or you can generate with a prompt, knn retrieval for initial chunks all taken care of

prompt = torch.randint(0, 1000, (1, 128))  # start with two chunks worth of sequence
sampled = wrapper.generate(prompt, filter_thres = 0.9, temperature = 1.0) # (1, <2049) terminates early if all <eos>
