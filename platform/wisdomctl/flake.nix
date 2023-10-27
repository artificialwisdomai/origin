{
  description = "Artificial Wisdom™ Cloud Platform CLI";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.poetry2nix = {
    url = "github:nix-community/poetry2nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # overlays = [
          #   poetry2nix.overlay
          #   (final: prev: {
          #     wisdomctl = prev.poetry2nix.mkPoetryApplication {
          #       projectDir = ./.;
          #     };
          #   })
          # ];
        };
        py = pkgs.python310.withPackages (ps: [
          ps.click ps.ocifs ps.pyarrow
          # Soft dependencies from pyarrow
          ps.pandas
        ]);
      in
      {
        # packages.default = pkgs.wisdomctl;
        devShells.default = pkgs.mkShell {
          packages = [ pkgs.poetry py ];
        };
      });
}
