{
  description = "";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # To enable CUDA support, set these to true and be patient. ~ C.
          config = {
            allowUnfree = false;
            cudaSupport = false;
          };
        };
        retro-pytorch = pkgs.python3Packages.buildPythonPackage {
          pname = "retro-pytorch";
          version = "0.3.8";
          src = pkgs.fetchFromGitHub {
            owner = "lucidrains";
            repo = "RETRO-pytorch";
            rev = "ab3c4a6f66341409b2b9105661682376355b4673";
            sha256 = "sha256-4zoV34SYkl0HBIjRQJYwGRvO0iIIn5QaLBdZzpzE3nU=";
          };
          propagatedBuildInputs = with pkgs.python3Packages; [
            autofaiss einops numpy sentencepiece torch tqdm
          ];
        };
        bravoDocs = pkgs.fetchFromGitHub {
          owner = "bravoserver";
          repo = "bravo";
          rev = "7be5d792871a8447499911fa1502c6a7c1437dc3";
          sha256 = "sha256-R8hSZsO82fdpjlDuE7toa6oB/FANTDfd3IDKWYy09R8=";
        };
        py = (pkgs.python3.withPackages (ps: with ps; [
          # All of the packages that we'll need for our app.
          faiss transformers
          retro-pytorch
          fastapi uvicorn
        ])
        # Override so that collisions between README.md are ignored.
        ).override (_: { ignoreCollisions = true; });
      in {
        packages = {
          default = py;
          bravo = bravoDocs;
        };
      });
}
