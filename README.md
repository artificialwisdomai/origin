# 🚀 RALMify: Information retrieval done right!

-[![Discord](https://img.shields.io/discord/1018236355177881630?logoColor=7289da&style=for-the-badge&logo=discord)](https://discord.gg/9HS8WCPQ27)
-![License](https://img.shields.io/github/license/artificialwisdomai/origin?logoColor=7289da&style=for-the-badge&logo=opensourceinitiative)

Use the Artificial Wisdom™ Cloud to build a retrieval augmented language model (RALM), a type
of **FRONTIER MODEL**, from your existing document collections and choice of existing LLM. You,
like the [designers](https://github.com/orgs/artificialwisdomai/people) have a dream
that the context can be managed effeciently, instead of depleted.

# What is a RALM?

A RALM, or retrieval augmented language model, is a type of **FRONTIER MODEL** that is
either trained from scratch, or augmented into an existing LLM. Our software augments
an existing LLM. By doing so, we wisely use our Planetary resources and improve information
retrival tremendously.

Our product offering enables you, to build your own **FRONTIER MODEL**, a retrieval
augmented langauge model [RALM], that offers these improvements:

* Can access an extensive set of knowledge bases, potentially all of recorded knowledge
* Retrieve knowledge dynamically
* Uderstandability
* Ceativity
* Flexibility
* Scalability
* eias reduction
* Real-time updates of knowledge
* Language context effeciency
* Cost effeciency
* Interaction with humans

# Is RALM the end of RAG?

RALM uses retrieval augmentation during generation, but it does not use the `RAG technique`.

The `RAG technique` also augments a generated response with semantic information from a large document
collection. A simple explination of RAG:

- Prior to inference
  - A mathmatical semantic representation of each document in a document collection is stored
- During inference
  - A text bundle is composed from:
    - Model instructions
    - Conversation turns
    - Prompt
  - The prompt, turns, and instructions semantic representation is compared to all documents within the
document store.
- A very limited number of documents are retrieved from the document store that share similar semantic
meaning.
- The following is then tokenized:
  - model instructions
  - conversation turns
  - propmt
  - retrieved documents
- The tokenized content is submitted to a stateless LLM which generates a response

This creates a problem that the LLM context windows are depleted during RAG.

The goal of any solution to this problem is simple:

**manage the context**

Our product transforms any preexisting LLM into a RALM.

with a similarity search is tokthe original token information used to build the embedding
is appended with similar document tokens, sent to a stateless LLM encoder, and then decoded
into an augmented language response. If the number of similar documents would exceed the typical
context window of 2048 tokens, they are either trunked, or summarized and then truncated, setting
a practical upper limit of about three hundred documents.

While `RAG techniques` rely on traditional tokenization and document embeddings, a RALM integrates
sophisticated techniques that encompass and exceed [Marginalia-style](https://en.wikipedia.org/wiki/Marginalia)
annotation methods. Instead of simply referencing the margins, as those that followed Fermat for
350 years to prove [his last therom](https://new.nsf.gov/news/350-years-later-fermats-last-theorem-finally),
RALMs engage in a far more dynamic process of facts-based grounded generation free of token window length
constraints. We believe that the upper bound that we would be willing to prove emperically of a retrieval
augmented language knowledge index is about ten trillion tokens.

A RALM doesn't just retrieve. RALMs augment and amplify facts, offering a superior approach to generating
truly original and creative output. By breaking free from the constraints of a limited document pool
and tokenization limits, a RALM offers more versatility, more nuance, improved understandability, and a
improved human language response.

# Why RALMs?

RALMs enhance generative language models with one or more knowledge indices for detailed knowledge
retrieval which enables domain-specific knowledge specialization, enhanced response accuracy, choice-driven 
knowledge inclusion, generation from nearly unlimited knowledge, cheap introduction of new knowledge,
all at vastly reduced costs without the need for exhaustive LLM retraining. And they can also
be told to enforce the right to be forgotten.

# What is an AKI?

An AKI, or augmented knowledge index, is a safe and explainable data structured from your existing
document collections used to improve the language performance of any Retrieval Augmented Langauge
Model (RALM).

# Installation

- Soooner or later, installation is coming for you!

# 🚀 Workflow Overview

**Learn.** Teach the computer about your document collections. Your document collections are transformed
into structured augmented knowledge indecies that a retreeival augmented language model uses during inference
to improve the quality and capability of a foundational LLM.

**Build.** Build a retreival augmented language model from your knowledge maps and open-source or source-available foundation LLMs such as [Meta AI's LLaMAv2](https://ai.meta.com/llama/).

**Deploy.** 👉 Local-first and cloud native, you choose where to operate, on our cloud, or yours!

# Build your own AKI (augmented knowledge index)

- Create a `DataLoader()` to read the authoritative documents in your document collection.
- Build a structured knowledge collection from your authoratiative document collection.
- Generate the proximity relationship between each section of the ephemeral structured knowledge collection.
- Map the two nearest neighbors between each section of the ephemeral structured knowledge collection.
- Build an epherarl structured knowledge collection. Use a [doi](wikipedia doi). For now, an Oracle Cloud resource
will do.
- Initialize an authoratative augmented knowledge index.
- Encode the ephemeral structured knowledge collection within the authoratative augmented knowledge index.

# Files and their purpose

```console
-rw-r--r-- 1 wise wise    52221672 Oct 11 15:28 00_train_realnews.chunk2seq.npy
-rw-r--r-- 1 wise wise  1671089536 Oct 11 15:28 00_train_realnews.chunks.npy
-rw-r--r-- 1 wise wise 10026536576 Oct 11 15:28 00_train_realnews.embeddings.npy
-rw-r--r-- 1 wise wise   208886304 Oct 17 04:20 00_train_realnews.neighbors.npy
-rw-r--r-- 1 wise wise     7789800 Oct 11 15:28 00_train_realnews.seq2chunk.npy
```

| Name | Purpose |
| --- | --- |
| `chunk2seq.npy` | Maps every chunk to every sequence |
| `seq2chunk.npy` | Maps every seqeunce to every chunk |
| `chunks.npy` | Contains an ephemeral structured knowledge collection |
| `neighbors.npy` | Contains the neighbor relationship for every chunk of the ephemeral structured knowledge collection |
| `embeddings.npy` | Contains information used to compare the contextual similarity of every document chunk within an ephemeral structured knowledge collection |

## Define the augmented knowledge index

You will need to generate the `definition_augmented_knowledge_index.json` by mapping
the `32` shards. I made mine with ❤️  [using neovim](https://github.com/neovim/neovim).

## Train augmented knowledge index

Maintainers: **Use `/mnt/datasets/knowledge.d`**

```console
artificialwisdomai $ hyperfine --runs 1 --warmup 0 --show-output --time-unit second --command-name train-index "bash 0003_train_index.sh"
```

- embeddings to train: 39,185,957

## Populate augmented knowledge index

**Use `/mnt/datasets/knowledge.d`**

Encode your unstructured document collection into a augmented knowledge index:

```console
artificialwisdomai $ hyperfine --style full --runs 1 --time-unit second "bash 0004_build_index.sh"
```

Output:
```console
Loading index...
Adding embedding shards...
1:	13055386 vectors 	Recall@1: 0.99776 	Queries / s: 821
2:	26108151 vectors 	Recall@1: 0.99417 	Queries / s: 143917
3:	39185957 vectors 	Recall@1: 0.99374 	Queries / s: 143596
4:	52257572 vectors 	Recall@1: 0.99266 	Queries / s: 143865
5:	65326366 vectors 	Recall@1: 0.99271 	Queries / s: 142573
6:	78385341 vectors 	Recall@1: 0.99185 	Queries / s: 142403
7:	91433964 vectors 	Recall@1: 0.99258 	Queries / s: 142929
8:	104465990 vectors 	Recall@1: 0.99204 	Queries / s: 141841
9:	117503863 vectors 	Recall@1: 0.99219 	Queries / s: 141482
10:	130549775 vectors 	Recall@1: 0.99179 	Queries / s: 141649
11:	143613989 vectors 	Recall@1: 0.99132 	Queries / s: 141207
12:	156673990 vectors 	Recall@1: 0.99128 	Queries / s: 140453
13:	169719433 vectors 	Recall@1: 0.99082 	Queries / s: 140632
14:	182759476 vectors 	Recall@1: 0.99065 	Queries / s: 140234
15:	195824122 vectors 	Recall@1: 0.99105 	Queries / s: 140309
16:	208888768 vectors 	Recall@1: 0.43205 	Queries / s: 138094
17:	221906946 vectors 	Recall@1: 0.98988 	Queries / s: 138865
18:	234991768 vectors 	Recall@1: 0.99096 	Queries / s: 137663
19:	248050555 vectors 	Recall@1: 0.98962 	Queries / s: 138195
20:	261116191 vectors 	Recall@1: 0.98995 	Queries / s: 138510
21:	274171019 vectors 	Recall@1: 0.98983 	Queries / s: 137367
22:	287229150 vectors 	Recall@1: 0.9894 	Queries / s: 136374
23:	300272031 vectors 	Recall@1: 0.98903 	Queries / s: 136122
24:	313335924 vectors 	Recall@1: 0.98862 	Queries / s: 135689
25:	326371539 vectors 	Recall@1: 0.9895 	Queries / s: 134413
26:	339434025 vectors 	Recall@1: 0.98882 	Queries / s: 134612
27:	352476827 vectors 	Recall@1: 0.98803 	Queries / s: 133871
28:	365537709 vectors 	Recall@1: 0.98798 	Queries / s: 133293
29:	378581403 vectors 	Recall@1: 0.9888 	Queries / s: 131567
30:	391632824 vectors 	Recall@1: 0.98873 	Queries / s: 132141
31:	404667216 vectors 	Recall@1: 0.98673 	Queries / s: 130735
95732:	417720130 vectors 	Recall@1: 0.98842 	Queries / s: 130320
33:	430755495 vectors 	Recall@1: 0.98779 	Queries / s: 130972
Saving index...

```

# The final augmented knowledge index

Our [Realnews](link-to-realnews-document-collection-in-oci) document collection:

31,158,659 unique RALM generative documents, consuming 118266 Mibibytes
 1,639,104 unique RALM testing and validation, consuming 6127 Mibibytes

The [Realnews](link-to-augmewnted-knowledge-index-in-oci) augmented knowledge index (AKI).

 16626 Mib used by similarity index
 50988 Mib used by structured document chunks
305926 Mib used by structured document embeddings
  6374 Mib used to map neighbors to chunks
   238 Mib used to map sequences to chunks
  1594 Mib used to map chunks to sequences

# Why Artificial Wisdom™ Cloud

The Artificial Wisdom™ Cloud is specifically designed to build your own unique Retrieval
Augmented Language Model (RALM), by modifying your choice of a transformer-based large language
models and your choice of augmented knowledge indeces (AKI). Whether you are local first, or renting
someone elses computer, you are still cloud native, and you should still consider reading
our [documentation](🚀 Artificial Wisdom RALM Notebook 🚀).
