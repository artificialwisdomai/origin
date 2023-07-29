FROM docker.io/nixos/nix

WORKDIR /app
COPY flake.nix flake.lock /app
# Fetch docs.
RUN nix \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes \
    build .#bravo -o bravo
ENV DOCS_PATH=/app/bravo/docs/
RUN nix \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes \
    build

COPY core.py /app/
ENTRYPOINT result/bin/uvicorn core:app --host=0.0.0.0 --port=$PORT
