Retreival Tranformer

# Overview

The retreival transformer is a type of transformer which is optimized via
gradient decent against a specific dataset.

## Environmental

There are many approaches to creating a  virtual environment. This example uses
`virtualenv`.

To install `virtualenv` on `Debian`:

```console
sudo apt install virtualenv
```

Next create a virtaul environment:

```console
virtualenv 0_experiment
```

Now activate the virtual environment:

```console
source 0_experiment/bin/activate
```
AAfter creating and activating a virtual environment you are
able to install the dependencies for this retreival transformer:

```console
pip install -r requirements.txt
```

Then train the retreival transformer on your dataset:

```console
python train.py
```

Finally inference the retreival transformer using your save dmodel and dataset:

```console
python inference.py
```

To modify the retreival vector index:

```console
REPROCESS=1 python train.py
```
