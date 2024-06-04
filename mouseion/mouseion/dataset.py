from collections import namedtuple
import json
import numpy
import torch
from torch.utils.data import Dataset, DataLoader

RetroTrainingElement = namedtuple("RetroTrainingElement", [
    "input_ids",
    "neighbor_ids",
    "labels"
])
class RetroDataset(Dataset):
    def __init__(self,
        datasetspec_path,
        pad_token_idx=0):

        with open(datasetspec_path, 'r') as file:
            dataspec = json.load(file)
        chunks = []
        chunks_to_sequence = []
        sequence_to_chunks = []
        embeddings = []
        neighbors = []
        self.pad_token_idx = pad_token_idx

        for spec in dataspec:
            np_chunks=numpy.load(spec['chunks'])
            chunks.append(np_chunks)
            chunks_to_sequence.append(numpy.load(spec['chunks_to_sequence']))
            sequence_to_chunks.append(numpy.load(spec['sequence_to_chunks']))
            embeddings.append(numpy.load(spec['embeddings']))
            np_neighbors=numpy.load(spec['neighbors'])
            neighbors.append(np_neighbors)

        self.chunks = numpy.concatenate(chunks, axis=0)
        self.chunks_to_sequence = numpy.concatenate(chunks_to_sequence, axis=0)
        self.sequence_to_chunks = numpy.concatenate(sequence_to_chunks, axis=0)
        self.embeddings = numpy.concatenate(embeddings, axis=0)
        self.neighbors = numpy.concatenate(neighbors, axis=0)
        self.max_num_chunks = len(self.sequence_to_chunks)

    def get_chunk_from_sequence(self, sequence_index):
        chunk_start_idx = self.sequence_to_chunks[sequence_index]
        if sequence_index + 1 < self.sequence_to_chunks.shape[0]:
            chunk_end_idx = self.sequence_to_chunks[sequence_index] + 1
        else:
            # this is the last sequence in the shard
            chunk_end_idx = self.chunks.shape[0]
        return numpy.arange(chunk_start_idx, chunk_end_idx)

    def get_chunk_with_sequence(self, sequence_index):
        return (self.chunks[sequence_index])

    def get_chunk_tokens(self, chunk_index, include_continuation_chunks=0):
        start_idx = chunk_index
        end_idx = chunk_index + 1
        while end_idx - start_idx - 1 < include_continuation_chunks and \
            end_idx < len(self.chunk_to_sequence) and \
            self.chunk_to_sequence[start_idx] == self.chunk_to_sequence[end_idx]:
            end_idx += 1
        return self.chunks[start_idx]

    def __len__(self):
        return len(self.sequence_to_chunks)

    def __getitem__(self, seq_index: int) -> RetroTrainingElement:
        input_chunk_indices = self.get_chunk_from_sequence(seq_index)

        # tokens per chunk
        input_ids = numpy.concatenate([
            self.get_chunk_tokens(chunk_index)
            for chunk_index in input_chunk_indices
        ])

        # neighbors * tokens per chunk
        neighbor_ids = numpy.stack([
            [
            self.get_chunk_with_sequence(neighbor_idx)
            for neighbor_idx in self.neighbors[seq_index]
            ]
        ])

        # labels - set to -100 at padded tokens
        labels = numpy.pad(input_ids[1:], (0, 1), constant_values=self.pad_token_idx).astype(numpy.int64)
        labels[labels == self.pad_token_idx] = -100

        return RetroTrainingElement(
            torch.from_numpy(input_ids.astype(numpy.int32)),
            torch.from_numpy(neighbor_ids.astype(numpy.int32)),
            torch.from_numpy(labels)
        )

    def get_chunks(self):
        return self.chunks

    def get_embeddings(self):
        return self.embeddings

    def get_sequence_to_chunks(self):
        return self.sequence_to_chunks

    def get_chunks_to_sequence(self):
        return self.chunks_to_sequence

if __name__ == "__main__":
    dataset = RetroDataset('/home/sdake/repos/origin/mouseion/datacollection_specs/train-arxiv.json')
    chunks_count = len(dataset.get_chunks())
    embedding_count = len(dataset.get_sequence_to_chunks())
    chunks_to_sequence = len(dataset.get_chunks_to_sequence())

