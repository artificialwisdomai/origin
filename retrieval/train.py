###
# Train a retrieval transformer with a dataset

import os
import time
import torch
import rich
from rich.progress import (
    BarColumn,
    MofNCompleteColumn,
    Progress,
    SpinnerColumn,
    TextColumn,
    TimeElapsedColumn,
    TimeRemainingColumn,
)

from retro_pytorch import RETRO, TrainingWrapper

###
# instantiate RETRO, fit it into the TrainingWrapper with correct settings

retro = RETRO(
    max_seq_len=2048,
    enc_dim=896,
    enc_depth=3,
    dec_dim=768,
    dec_depth=12,
    dec_cross_attn_layers=(1, 3, 6, 9),
    heads=8,
    dim_head=64,
    dec_attn_dropout=0.25,
    dec_ff_dropout=0.25,
    use_deepnet=True,
).cuda()

###
# We need a functional deepspeed integration.
#engine = deepspeed.init_inference(model=retro)

###
# Training wrapper: an initializer to pull together all of the stuff to train
# mkdir ./chunks - or this will fail
# Changing the glob to `*md` or `*jsonl` is neecessary.
# I have used:
# https://github.com/istio/istio.io/tree/master/content/en
# https://huggingface.co/datasets/togethercomputer/RedPajama-Data-1T-Sample
wrapper = TrainingWrapper(
    retro=retro,
    knn=2,
    chunk_size=64,
    documents_path="/models/RedPajama-Data-1T-Sample",
    glob="**/*.jsonl",
    chunks_memmap_path="./chunks/train.chunks.dat",
    seqs_memmap_path="./chunks/train.seq.dat",
    doc_ids_memmap_path="./chunks/train.doc_ids.dat",
    max_chunks=1_000_000,
    max_seqs=100_000,
    knn_extra_neighbors=100,
    processed_stats_json_path="./processed-stats.json",
    # TODO(sdake): Poor constraints enforcement creates a charlie foxtrot here
    max_index_memory_usage="100m",
    current_memory_available="1G",
)

retro.train()
optim = wrapper.get_optimizer(lr=3e-4, wd=0.01)

progress_bar = Progress(
    TextColumn("[progress.description]{task.description}"),
    TextColumn("[progress.percentage]{task.percentage:>3.0f}%"),
    SpinnerColumn(),
    BarColumn(),
    TextColumn("•"),
    TextColumn("{task.fields[loss]}"),
    TextColumn("•"),
    TimeElapsedColumn(),
    TextColumn("•"),
    TimeRemainingColumn(),
)

loss = 0.00
EPOCH_MAX = 15

# progress bar documentation: https://rich.readthedocs.io/en/stable/progress.html
# Reading the upstream code and examples directory recommended

with progress_bar:
    progress_bar.console.print(
        "[link=https://github.com/artificialwisdomai/origin]Artificial Wisdom™[/] Retreival Transformer Training",
        style="#008080",
    )
    progress_bar.console.print(
        "• retrieval_model=artificialwisdomai/retroformer • foundation_model=mosaicml/mpt30b •",
        style="#008080",
    )
    for epoch in range(EPOCH_MAX):
        dataloader = iter(wrapper.get_dataloader(batch_size=4, shuffle=True))
        task_id = progress_bar.add_task(
            description="Epoch {}".format(epoch), loss="0.00", total=len(dataloader)
        )
        for seq, retrieved in dataloader:
            seq, retrieved = seq.cuda(), retrieved.cuda()
            loss = retro(seq, retrieved, return_loss=True)
            loss.backward()
            optim.step()
            optim.zero_grad()
            progress_bar.update(task_id, loss="loss={:2.2f}".format(loss))
            progress_bar.advance(task_id)
