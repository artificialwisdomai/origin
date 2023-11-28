{
  description = "Artificial Wisdom™ Cloud Platform CLI";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        py = pkgs.python310.withPackages (ps: with ps; [
          # Cloud-native: Access to k8s API, M&M
          kubernetes prometheus_client
          # FAISS
          faiss
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
