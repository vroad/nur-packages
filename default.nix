{ pkgs ? import (import ./nix/sources.nix).nixpkgs { } }:
{
  modules = import ./modules; # NixOS modules

  gn = pkgs.callPackage ./pkgs/development/tools/build-managers/gn { };
  depot-tools = pkgs.callPackage ./pkgs/development/tools/depot-tools { };
  looking-glass-client = pkgs.callPackage ./pkgs/development/virtualization/looking-glass-client { };
}
