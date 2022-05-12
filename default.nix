{ pkgs ? import (import ./nix/sources.nix).nixpkgs { } }:
{
  modules = import ./modules; # NixOS modules

  looking-glass-client = pkgs.callPackage ./pkgs/development/virtualization/looking-glass-client { };
}
