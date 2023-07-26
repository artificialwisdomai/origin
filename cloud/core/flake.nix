{
  description = "";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        py = pkgs.python3.withPackages (ps: with ps; [
          faiss transformers
          fastapi uvicorn
        ]);
      in {
        packages.default = py;
      });
}
