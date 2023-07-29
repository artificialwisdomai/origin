Artificial Wisdom™ Cloud Core API

This is a quick and dirty OpenAPI-oriented JSON-over-HTTP service for
configuring our cloud core stuff, written in Python.

# Nix

## Build

We need to build a Python interpreter which can import all of the various
modules that we want to use.

If you have Nix installed with Nix flakes enabled, then:

```console
nix build .#bravo -o bravo && export DOCS_PATH=bravo
nix build
```

This will both build the Python environment and also set up a `bravo` folder
for docs.

If Nix flakes aren't enabled, then it's still possible but requires flags:

```console
nix --extra-experimental-features nix-command --extra-experimental-features flakes build .#bravo -o bravo
nix --extra-experimental-features nix-command --extra-experimental-features flakes build
```

Now the resulting interpreter can be used as if from a virtualenv:

```console
result/bin/uvicorn --host=0.0.0.0 --port=8000 core:app
```

# Podman/Docker

If Nix isn't installed, there is a Podman-compatible Dockerfile which can be
used to build and run the entire service at once. The Dockerfile executes the
same `nix build` and `uvicorn` commands as above, but within a container.

## Fetch example docs

There's several possible documentation sources that you can try. Here's one
from my old Minecraft server, Bravo:

```console
git clone https://github.com/bravoserver/bravo
export DOCS_PATH=bravo/docs/
```

To try anything else, change the `DOCS_PATH` environment variable.

## Build and run

Here's the basic recipe for Podman:

```console
export IMAGE=$(podman build cloud/core)
podman run --env-host -e PORT=8000 -p 8000:8000 $IMAGE
```

To use with Docker, call `docker` instead of `podman`.

The `--env-host` flag can be replaced with `-e DOCS_PATH=...` explicitly. This
will be important for cloud deployment **later**.

# Usage

Once the service is running, visit something like `/docs` or `/redoc` to get
an OpenAPI documentation console. From there, try out `/v0/infer`. (I would
love to tell you to open up port 8000 on `localhost` using HTTP, but I have to
use prose in order to get past CI.)

# Known issues

* About 400M of stuff are downloaded from HF every time the container starts.
  We should retrieve the model weights in advance.
* All libraries are CPU-only. It should be straightforward to build with CUDA
  support, although it may take a few hours, which means that I don't want to
  recommend that anybody build the container with CUDA support because it
  won't be cached in a Nix store!
