{
  description = "Bytehound - a memory profiler for Linux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

outputs = { self, nixpkgs, flake-utils, rust-overlay }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ (import rust-overlay) ];
      };

      # Use Rust stable
      rustToolchain = pkgs.rust-bin.stable.latest.default;
    in
    {
      # Development shell
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          rustToolchain
          pkg-config
          cmake
          gcc
          glibc.dev
          elfutils
          rust-analyzer
          clippy
          rustfmt
          yarn
          nodejs_24
        ];
        
        shellHook = ''
          echo "Bytehound development environment"
          echo "Rust version: $(rustc --version)"
        '';
      };
    }
  );
}