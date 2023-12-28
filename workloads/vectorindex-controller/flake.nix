{
  description = "Artificial Wisdom™ Cloud Platform CLI";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        sentence-transformers = pkgs.python310.pkgs.buildPythonPackage rec {
          pname = "sentence-transformers";
          version = "2.2.2";

          src = pkgs.fetchPypi {
            inherit pname version;
            sha256 = "sha256-28YBY7J94hB2yaMNJLW3tvoFFB1ozyVT+pp3v3mikTY=";
          };

          propagatedBuildInputs = with pkgs.python310.pkgs; [
            huggingface-hub nltk scikit-learn scipy sentencepiece tokenizers torch torchvision tqdm transformers
          ];

          doCheck = false;
        };
        mouseion = pkgs.python310.pkgs.buildPythonPackage rec {
          pname = "mouseion";
          version = "0.1.0";

          src = pkgs.fetchFromGitHub {
            owner = "artificialwisdomai";
            repo = "origin";
            rev = "64354d66488f00f27b8e9732dfea41ed01933ee6";
            sha256 = "sha256-IQkIvoAhfJeFKXM/HheRrSXK/7ndTiZ93JbMbKex90A=";
          };
          sourceRoot = "${src.name}/mouseion";
          format = "pyproject";

          buildInputs = with pkgs.python310.pkgs; [
            poetry-core
          ];
          propagatedBuildInputs = with pkgs.python310.pkgs; [
            numpy tqdm faiss
          ];

          doCheck = false;
        };
        py = pkgs.python310.withPackages (ps: with ps; [
          # Debugging
          tqdm
          # Cloud-native: Access to k8s API, M&M
          kubernetes prometheus_client
          # mouseion
          mouseion
          # FAISS
          faiss
          # Sentence Transformers
          sentence-transformers
          # Access to Feather files in OCI buckets
          ocifs pyarrow
          # Soft dependencies from pyarrow
          pandas
        ]);
      in
      {
        packages = {
          default = py;
          oci = pkgs.ociTools.buildContainer {
            args = [ (pkgs.writeScript "run.sh" ''
              #!${pkgs.bash}/bin/bash
              exec ${py}/bin/python ${./vectorindex-controller.py}
            '').outPath ];
          };
        };
        devShells.default = pkgs.mkShell {
          packages = [ py pkgs.python310Packages.pyflakes ];
        };
      });
}
