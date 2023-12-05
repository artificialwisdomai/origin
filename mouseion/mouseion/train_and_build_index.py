import argparse
import faiss
import json
import numpy
import tqdm
import pathlib

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

    index = faiss.index_factory(dim, args.index_type, faiss.METRIC_L2)

    if args.use_gpus:
        gpu_resources = []
        for i in range(faiss.get_num_gpus()):
            res = faiss.StandardGpuResources()
            res.setTempMemory(2**20)
            gpu_resources.append(res)

        co = faiss.GpuMultipleClonerOptions()
        co.useFloat16 = True
        co.usePrecomputed = True
        co.shard = True
        co.resources = gpu_resources

        index = faiss.index_cpu_to_all_gpus(index, co)

    with tqdm.tqdm(total=total_embeddings, desc="Embeddings") as progress:
        for shard_info in spec["shards"]:
            try:
                shard_embeddings = numpy.load(shard_info["embeddings"], mmap_mode="r")
            except Exception as e:
                print(f"Error loading shard: {e}")
                continue

            shard_size = shard_embeddings.shape[0]

            if not is_trained:
                train_data = shard_embeddings.astype('float32', copy=False)
                index.train(train_data)
                is_trained = True

            for i in range(0, shard_size, args.batch_size):
                end = i + args.batch_size
                batch = shard_embeddings[i:end].astype('float32', copy=False)
                index.add(batch)
                progress.update(batch.shape[0])

    if args.use_gpus:
        index = faiss.index_gpu_to_cpu(index)

    faiss.write_index(index, args.output)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--spec", type=pathlib.Path, required=True)
    parser.add_argument("--index-type", type=str, required=True)
    parser.add_argument("--use-gpus", action="store_true")
    parser.add_argument("--output", type=str, required=True)
    parser.add_argument("--batch-size", type=int, default=32768)
    args = parser.parse_args()

    main(args)
