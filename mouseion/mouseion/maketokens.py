from tasks import Task, TaskProcessor, ProgressType
from typing import Dict
from multiprocessing import Queue
import orjson
import os
from pathlib import Path
from transformers import T5Tokenizer
import numpy as np
from multiprocessing import Manager
import torch
from sentence_transformers import SentenceTransformer


def get_tokenizer():
    # Set model_max_length to suppress warning
    #    return AutoTokenizer.from_pretrained("t5-base", use_fast=False, model_max_length=10000)
    tokenizer = T5Tokenizer.from_pretrained("t5-small")
    return tokenizer


def function_load_jsonl(size: int, progress_queue: Queue, **kwargs) -> list:
    file_path = "/mnt/datasets/arxiv/arxiv_trained_minimized.json"
    split_count = kwargs['split_count']
    file_size = os.path.getsize(file_path)
    file = open(file_path)
    progress_queue.put(10000000)

    splits = [[] for _ in range(32)]

    for i, line in enumerate(file):
        splits[i % split_count].append(orjson.loads(line))
        progress_queue.put(len(line))
    return splits


def function_tokenize(size: int, progress_queue: Queue, **kwargs) -> list:
    data = kwargs['data']
    path_prefix = Path(kwargs['path_prefix'])

    sequence_to_chunks_pathname = Path(f'{path_prefix}_sequence_to_chunks.npy')
    chunks_to_sequence_pathname = Path(f'{path_prefix}_chunks_to_sequence.npy')
    tokenized_pathname = Path(f'{path_prefix}_tokenized.npy')
    max_chunks=kwargs['max_chunks']
    chunk_column_size=kwargs['chunk_column_size']

    chunks_buffer = np.empty(shape=(max_chunks, chunk_column_size), dtype=np.uint16)
    sequence_to_chunk_index = []  # Index from seq_idx to idx of first chunk in sequence
    chunk_to_sequence_index = []  # Index from chunk to seq_idx
    chunks_total = 0

    tokenizer = get_tokenizer()
    for sequence, line in enumerate(data):
        tokens = tokenizer.encode(
            line["article_text"],
            return_tensors="np",
            add_special_tokens=True,
            padding=True,
            pad_to_multiple_of=chunk_column_size,
        )[0]
        tokens = tokens.reshape(-1, chunk_column_size)
        chunk_row_size = tokens.shape[0]
        chunks_buffer[chunks_total : (chunks_total + chunk_row_size), :] = tokens
        sequence_to_chunk_index.append(chunks_total)

        chunk_to_sequence_index += [sequence] * chunk_row_size
        chunks_total += chunk_row_size;
        progress_queue.put(1)

    np.save(tokenized_pathname, chunks_buffer[:chunks_total, :])
    np.save(sequence_to_chunks_pathname, np.array(sequence_to_chunk_index, dtype=np.int64))
    np.save(chunks_to_sequence_pathname, np.array(chunk_to_sequence_index, dtype=np.int32))
    return [chunks_buffer[:chunks_total, :]]

def function_embed(size: int, progress_queue: Queue, **kwargs) -> list:
    path_prefix = Path(kwargs['path_prefix'])
    embed_path = Path(f'{path_prefix}_embedding')
    chunks = kwargs['chunks']
    batch_size = kwargs['batch_size']
    model = SentenceTransformer("all-MiniLM-L6-v2")

    tokenizer = get_tokenizer()

    decoded_batch_seqs = []
    for chunk in chunks:
        progress_queue.put(1)
        decoded_batch_seqs.append(tokenizer.decode(chunk, skip_special_tokens=True))

    sentence_embeddings = model.encode(
        decoded_batch_seqs,
        batch_size=batch_size,
        device="cuda" if torch.cuda.is_available() else "cpu",
        convert_to_numpy=True,
        output_value="sentence_embedding",
        normalize_embeddings=True,
    )
    sentence_embeddings = np.stack(sentence_embeddings).astype(np.float16)
    np.save(embed_path, sentence_embeddings)


if __name__ == "__main__":
    file_path = "/mnt/datasets/arxiv/arxiv_trained_minimized.json"
    file_size = os.path.getsize(file_path)
    split_count = 32

    tasks_loadjson = [
        Task(
            id=0,
            description="Load jsonl",
            size=file_size,
            progress_type=ProgressType.MIBI_PER_SECOND,
            function=function_load_jsonl,
            path_prefix='/mnt/datasets/arxiv/00_arxiv_train',
            split_count=split_count
        ),
    ]

    processor = TaskProcessor(command="RETRO Tokenizer", max_workers=50)
    processor.add_tasks(tasks_loadjson)
    processor.process_tasks()
    splits = processor.get_task_result(0)

    ###
    #
    # Create 32 tasks to tokenize data

    for i, split in enumerate(splits):
        task_tokenize = [
           Task(
               id=i + 1,
               size=len(splits),
               description=f'Tokenize {i:02}',
               progress_type=ProgressType.ITERATIONS_PER_SECOND,
               function=function_tokenize,
               path_prefix=f'/home/sdake/datasets/arxiv/{i:02}_arxiv_train',
               data=split,
               chunk_column_size=64,
               max_chunks=50000000,
           )
        ]
        processor.add_tasks(task_tokenize)

    processor.process_tasks()

    ###
    #
    # Create 32 tasks to embed data

    for i in range(split_count):
        chunks=processor.get_task_result(i+1)[0]
        task_embed = [
           Task(
               id=i + 33,
               description=f'Embed {i:02}',
               progress_type=ProgressType.ITERATIONS_PER_SECOND,
               function=function_embed,
               path_prefix=f'/home/sdake/datasets/arxiv/{i:02}_arxiv_train',
               size=len(chunks),
               batch_size=64,
               chunks=chunks
           )
        ]
        processor.add_tasks(task_embed)

    processor.process_tasks()
    result = processor.get_task_result(1)
    print(f"Done tokenizing.")
