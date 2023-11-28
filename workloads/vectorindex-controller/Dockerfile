FROM nixos/nix

WORKDIR /app/
COPY flake.nix flake.lock /app/
RUN nix --extra-experimental-features 'nix-command flakes' build

COPY vectorindex-controller.py /app/

CMD ["/app/result/bin/python", "/app/vectorindex-controller.py"]
