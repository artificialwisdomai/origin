import argparse
import json
import numpy
import tqdm
import pathlib

from .indexbuilder import GPUIndexBuilder, IndexBuilder

def main(args):
    """
    Determine if an output directory exists.
    """
    if not pathlib.Path(args.output).is_dir():
        raise ValueError(f"The output path is invalid {args.output}")

    """
    Combines numpy embeddings from multiple npy files into a FAISS index.
    """
    try:
        spec = json.load(args.spec.open("r"))
    except Exception as e:
        print(f"Error reading spec file: {e}")
        return

    total_embeddings = sum([numpy.load(shard["embeddings"], mmap_mode="r").shape[0] for shard in spec["shards"]])
    is_trained = False

    try:
        first_shard = numpy.load(spec["shards"][0]["embeddings"], mmap_mode="r")
    except Exception as e:
        print(f"Error loading shard: {e}")
        return

    dim = first_shard.shape[1]
    print(f'dimensionality is {dim}')

    builder_cls = GPUIndexBuilder if args.use_gpus else IndexBuilder
    builder = builder_cls(dim, args.index_type)

    with tqdm.tqdm(total=total_embeddings, desc="Embeddings") as progress:
        for shard_info in spec["shards"]:
            try:
                shard_embeddings = numpy.load(shard_info["embeddings"], mmap_mode="r")
            except Exception as e:
                print(f"Error loading shard: {e}")
                continue

            shard_size = shard_embeddings.shape[0]

            if not is_trained:
                builder.train(shard_embeddings)
                is_trained = True

            for i in range(0, shard_size, args.batch_size):
                end = i + args.batch_size
                batch = shard_embeddings[i:end]
                builder.add(batch)
                progress.update(batch.shape[0])

    builder.write_path(args.output)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--spec", type=pathlib.Path, required=True)
    parser.add_argument("--index-type", type=str, required=True)
    parser.add_argument("--use-gpus", action="store_true")
    parser.add_argument("--output", type=str, required=True)
    parser.add_argument("--batch-size", type=int, default=32768)
    args = parser.parse_args()

    main(args)
