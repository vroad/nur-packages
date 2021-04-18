{ pkgs ? import (import ./nix/sources.nix).nixpkgs { } }:
rec {
  gn = pkgs.callPackage ./pkgs/development/tools/build-managers/gn { };
  depot-tools = pkgs.callPackage ./pkgs/development/tools/depot-tools { };
  angle = pkgs.xorg.callPackage ./pkgs/development/libraries/angle { inherit gn depot-tools; };
  angle-dev-tools = pkgs.callPackage ./pkgs/development/tools/angle-dev-tools { };
}
