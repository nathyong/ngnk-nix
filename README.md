# Nix flake for [ngn/k](https://codeberg.org/ngn/k)

This repository defines a nixpkgs overlay and nix flake for ngn's implementation of the K language (k6 dialect).

The interpreter is automatically tested on Linux x86_64 and MacOS x86_64 via Nix.

The actual Nix package for `k` is located at [`k/default.nix`](k/default.nix).  Currently this is built with Clang 12, and comes with a convenience wrapper that allows it to be invoked as `k` in both interactive and batch mode.
