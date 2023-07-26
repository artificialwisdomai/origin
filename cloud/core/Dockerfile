FROM docker.io/nixos/nix

WORKDIR /app
COPY flake.nix flake.lock /app
RUN nix \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes \
    build

COPY core.py /app/
ENTRYPOINT uvicorn core:app --host=0.0.0.0 --port=$PORT
