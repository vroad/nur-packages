{ ... }:
let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  qemu = with pkgs; callPackage ./pkgs/applications/virtualization/qemu {
    inherit (darwin.apple_sdk.frameworks) CoreServices Cocoa Hypervisor;
    inherit (darwin.stubs) rez setfile;
    inherit (darwin) sigtool;
    libjack2 = libjack2-pipewire;
  };
in
{
  modules = import ./modules; # NixOS modules

  libjack2-pipewire = pkgs.callPackage ./pkgs/applications/virtualization/qemu/libjack2-pipewire.nix { };
  qemu_kvm = pkgs.lowPrio (qemu.override { hostCpuOnly = true; });
}
