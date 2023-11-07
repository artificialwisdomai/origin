{
  description = "Artificial Wisdom™ Cloud Platform CLI";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
	# Need a recent HF Datasets release due to a buggy interaction with
	# newer fsspec
        datasets = pkgs.python310Packages.datasets.overrideAttrs (_: _: rec {
          version = "2.14.6";
          src = pkgs.fetchFromGitHub {
            owner = "huggingface";
            repo = "datasets";
            rev = version;
            sha256 = "sha256-AncyuDiBNPVleSVsxwsJ27SJzXsvQYAVq8DOOG40rP4=";
          };
        });
        py = pkgs.python310.withPackages (ps: with ps; [
          # Cloud-native: Access to k8s API, M&M
          kubernetes prometheus_client
          # Access to HF Datasets
          datasets
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
              exec ${py}/bin/python ${./dataset-controller.py}
            '').outPath ];
          };
        };
        devShells.default = pkgs.mkShell {
          packages = [ py ];
        };
      });
}
