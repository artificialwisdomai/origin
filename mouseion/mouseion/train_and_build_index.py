import argparse
import json
import numpy
import tqdm
import pathlib

from multiprocessing import Queue
from indexbuilder import GPUIndexBuilder, IndexBuilder
from tasks import Task, TaskProcessor, ProgressType


def function_train_index(size: int, progress_queue: Queue, **kwargs) -> list:
    """
    Determine if an output directory exists.
    """

    """
    Combines numpy embeddings from multiple numpy files into a FAISS index.
    """
    kwarg_output = kwargs['output']
    kwargs_index_type = kwargs['index_type']
    kwargs_batch_size = kwargs['batch_size']
    kwargs_specs = kwargs['specs']

    segments = list()
    segment = numpy.load(specs[0]['embeddings'])

    dimension = segment.shape[1]
    split_size = segment.shape[0]

    builder_cls = GPUIndexBuilder
    builder = builder_cls(dimension, kwargs_index_type)
    builder.train(segment)

    shard_total_size=0
    for i, spec in enumerate(specs):
        segment = numpy.load(spec['embeddings'])
        for j in range(0, split_size, kwargs_batch_size):
            batch = segment[j:j+kwargs_batch_size]
            builder.add(batch)
            progress_queue.put(kwargs_batch_size)
            shard_total_size += kwargs_batch_size

    builder.write_path(kwarg_output)
    return []

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--specs", type=pathlib.Path, required=True)
    parser.add_argument("--index-type", type=str, required=True)
    parser.add_argument("--use-gpus", action="store_true")
    parser.add_argument("--output", type=str, required=True)
    parser.add_argument("--batch-size", type=int, default=32768)
    args = parser.parse_args()

    specs = json.load(args.specs.open("r"))
    total_embeddings = sum([numpy.load(shard["embeddings"], mmap_mode="r").shape[0] for shard in specs])


    tasks_train_index = [
        Task(
            id=0,
            description="Train index",
            size=total_embeddings,
            progress_type=ProgressType.ITERATIONS_PER_SECOND,
            function=function_train_index,
            index_type=args.index_type,
            use_gpus=args.use_gpus,
            specs=specs,
            output=args.output,
            batch_size=args.batch_size,
        )
    ]

    processor = TaskProcessor(command="RETRO Index Trainer", max_workers=50)
    processor.add_tasks(tasks_train_index)
    processor.process_tasks()
