
# Use

There are three steps:
- convert datasets to numpy arrays
- generate embeddings
- train and build the index

## Train and build the index

Step2 is all that is currently documented or implemented.
```console
poetry run step2
```

# Install

## Update lockfile

```console
poetry lock
```

## Build package

```console
poetry build
```

## Install to a virtual environment

```console
poetry install
```

## Removal

```console
wise@wise-a40x1-1:~/origin/mouseion$ poetry env list
mouseion-TcVnHjA0-py3.11 (Activated)
wise@wise-a40x1-1:~/origin/mouseion$ poetry env remove mouseion-TcVnHjA0-py3.11
Deleted virtualenv: /home/wise/.cache/pypoetry/virtualenvs/mouseion-TcVnHjA0-py3.11
```

# Development

## Create a development environment

```console
poetry shell
```

[Defining installation](https://python-poetry.org/docs/pyproject/)
[Using Poetry virtual environments](https://python-poetry.org/docs/basic-usage/#using-your-virtual-environment)
