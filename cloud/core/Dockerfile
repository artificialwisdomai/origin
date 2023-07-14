FROM docker.io/nixos/nix

RUN nix-env -f '<nixpkgs>' -i \
    -E 'pkgs: (pkgs {}).python3.withPackages (ps: [ps.fastapi ps.uvicorn])'

RUN mkdir /app/
WORKDIR /app
COPY core.py /app/

ENTRYPOINT uvicorn core:app --host=0.0.0.0 --port=$PORT
