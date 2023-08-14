{
  inputs = {
    fenix.url = "github:nix-community/fenix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, fenix }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        target = "thumbv7em-none-eabihf";
        toolchain = with fenix.packages.${system};
          combine [
            complete.toolchain
            targets.${target}.latest.rust-std
          ];
      in {
        devShell = with pkgs;
          mkShell {
            buildInputs = [
              gcc
              toolchain
              clang
              llvm
              elfutils
              gcc-arm-embedded
              openocd
              svd2rust
              qemu
              cargo-binutils
              cargo-generate
            ];
          };
      });
}
