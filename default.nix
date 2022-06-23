{ ... }:
let
  sources = import ./nix/sources.nix;
in
{
  modules = import ./modules; # NixOS modules
}
