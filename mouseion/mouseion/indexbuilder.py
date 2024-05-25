import numpy as np

import faiss

def normedEmbeds(arr):
    """
    Normalize an array with the L2 metric.

    This is an in-place operation, but the input value is trashed; use the
    return value, please.
    """
    # https://github.com/facebookresearch/faiss/wiki/MetricType-and-distances
    rv = np.array(arr, dtype="float32", copy=False)
    faiss.normalize_L2(rv)
    return rv

class IndexBuilder:
    "An incremental index builder."

    def __init__(self, dimension, factory):
        """
        Prepare an index.

        The dimension is a positive number specifying the width of the vectors.
        The factory is a string; see
        https://github.com/facebookresearch/faiss/wiki/The-index-factory for
        examples and a grammar.
        """
        self.index = faiss.index_factory(dimension, factory, faiss.METRIC_L2)

    def train(self, data):
        "Train the index on some training data."
        self.index.train(normedEmbeds(data))

    def add(self, data):
        "Add rows of data to the index."
        self.index.add(normedEmbeds(data))

    def write_path(self, path):
        "Write the index to a path on disk."
        faiss.write_index(self.index, path)


def limitedGPUResource(size):
    res = faiss.StandardGpuResources()
    res.setTempMemory(size)
    return res

class GPUIndexBuilder(IndexBuilder):
    "An index builder which uses GPU acceleration."

    def __init__(self, *args):
        super(GPUIndexBuilder, self).__init__(*args)

        co = faiss.GpuMultipleClonerOptions()
        co.useFloat16 = True
        co.usePrecomputed = True
        co.shard = True
        co.resources = [limitedGPUResource(2**32)
                        for _ in range(faiss.get_num_gpus())]

        self.index = faiss.index_cpu_to_all_gpus(self.index, co)

    def write_path(self, path):
        faiss.write_index(faiss.index_gpu_to_cpu(self.index), path)
