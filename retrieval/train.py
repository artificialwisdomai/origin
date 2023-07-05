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
from rich.console import Console
from rich.style import Style
from rich.theme import Theme

###
# Artificial Wisdom™ Triadic Color scheme

COLOR_TEXT = "#00EA8C"
COLOR_EXTRA = "#EA8C00"
COLOR_EXTRENUOUS = "#8C00EA"

theme = Theme(
    {
        "aw.a": Style.parse(COLOR_TEXT),
        "aw.b": Style.parse(COLOR_EXTRA),
        "aw.c": Style.parse(COLOR_EXTRENUOUS),
        "repr.ellipsis": Style.parse(COLOR_TEXT),
        "repr.filename": Style.parse(COLOR_TEXT),
        "repr.path": Style.parse(COLOR_TEXT),
        "progress.data.speed": Style.parse(COLOR_TEXT),
        "progress.description": Style.parse(COLOR_TEXT),
        "progress.download": Style.parse(COLOR_TEXT),
        "progress.elapsed": Style.parse(COLOR_TEXT),
        "progress.filesize": Style.parse(COLOR_TEXT),
        "progress.filesize.total": Style.parse(COLOR_TEXT),
        "progress.percentage": Style.parse(COLOR_TEXT),
        "progress.remaining": Style.parse(COLOR_TEXT),
        "progress.spinner": Style.parse(COLOR_TEXT),
    }
)

console = Console(theme=theme)

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
    documents_path="/home/sdake/en",
#    models/RedPajama-Data-1T-Sample",
    glob="**/*.md",
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
    TextColumn(" ", style=COLOR_EXTRA),
    SpinnerColumn(spinner_name="aesthetic", style=COLOR_TEXT),
    TextColumn("•", style=COLOR_EXTRA),
    TextColumn("[progress.description]{task.description}"),
    TextColumn("•", style=COLOR_EXTRA),
    TextColumn("[progress.percentage]{task.percentage:>3.0f}%"),
    TextColumn("•", style=COLOR_EXTRA),
    BarColumn(style=COLOR_TEXT, complete_style=COLOR_EXTRA),
    TextColumn("•", style=COLOR_EXTRA),
    TextColumn("{task.fields[loss]}", style=COLOR_TEXT),
    TextColumn("•", style=COLOR_EXTRA),
    TimeElapsedColumn(),
    TextColumn("•", style=COLOR_EXTRA),
    TimeRemainingColumn(),
    TextColumn("•", style=COLOR_EXTRA),
    console=console,
)

loss = 0.00
EPOCH_MAX = 15

# progress bar documentation: https://rich.readthedocs.io/en/stable/progress.html
# Reading the upstream code and examples directory recommended

with progress_bar:
    progress_bar.console.print(
        "[link=https://github.com/artificialwisdomai/origin]Artificial Wisdom™[/link] NLP BluBox",
        style=COLOR_EXTRENUOUS,
    )
    progress_bar.console.print(
        " [aw.a]•[/aw.a] [aw.b]retrieval_model[/aw.b][aw.a]=[/aw.a][aw.b]artificialwisdomai[/aw.b][aw.a]/[/aw.a][aw.b]retroformer [aw.a]•[/aw.a] [aw.b]foundation_model[/aw.b][aw.a]=[/aw.a][aw.b]mosaicml[/aw.b][aw.a]/[/aw.a][aw.b]mpt30b[/aw.b] [aw.a]•[/aw.a] "
    )
    for epoch in range(EPOCH_MAX):
        dataloader = iter(wrapper.get_dataloader(batch_size=4, shuffle=True))
        task_id = progress_bar.add_task(
            description="Epoch {}".format(epoch), loss="loss=nil", total=len(dataloader)
        )
        for seq, retrieved in dataloader:
            seq, retrieved = seq.cuda(), retrieved.cuda()
            loss = retro(seq, retrieved, return_loss=True)
            loss.backward()
            optim.step()
            optim.zero_grad()

            # TODO(sdake): Unclear this meets specifications. I have not yet
            # successfully restored a checkpoint.
            torch.save(
                {
                    "epoch": epoch,
                    "model_state_dict": retro.state_dict(),
                    "optimizer_state_dict": optim.state_dict(),
                    "loss": loss,
                },
                "model.pt{}".format(epoch),
            )
            progress_bar.update(task_id, loss="[aw.a]loss[/aw.a][aw.b]=[/aw.b][aw.a]{:2.2f}[/aw.a]".format(loss))
            progress_bar.advance(task_id)
