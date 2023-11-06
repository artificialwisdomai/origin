{
  description = "Artificial Wisdom™ Cloud Platform CLI";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
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
        packages.default = py;
        devShells.default = pkgs.mkShell {
          packages = [ py ];
        };
      });
}
