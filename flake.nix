{
  description = "ngn/k flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    {
      overlay = final: prev: { k = final.callPackage ./k {}; };
    } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          overlays = [ self.overlay ];
          inherit system;
        };
      in
      rec {
        packages = with pkgs; { inherit k; };
        defaultPackage = packages.k;
        apps.k = flake-utils.lib.mkApp { drv = packages.k; };
        defaultApp = apps.k;
      }
    );
}
