{ pkgs ? import (import ./nix/sources.nix).nixpkgs { } }:
let
  gn = pkgs.callPackage ./pkgs/development/tools/build-managers/gn { };
  depot-tools = pkgs.callPackage ./pkgs/development/tools/depot-tools { };
in
{
  inherit depot-tools gn;
}
