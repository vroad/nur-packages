{ pkgs ? import (import ./nix/sources.nix).nixpkgs { } }:
with pkgs;
{
  modules = import ./modules; # NixOS modules

  qemu = callPackage ./pkgs/applications/virtualization/qemu {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa Hypervisor;
    inherit (darwin.stubs) rez setfile;
    python = python3;
  };

  looking-glass-client = callPackage ./pkgs/development/virtualization/looking-glass-client { };
}
