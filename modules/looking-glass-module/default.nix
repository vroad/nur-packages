{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.looking-glass-module;
in
{
  options.looking-glass-module = {
    enable = mkEnableOption "LookingGlass kernel module";
    kernel = mkOption {
      type = types.package;
      description = "Linux kernel to build the module with";
      example = "pkgs.linuxPackages_5_10.kernel";
    };
    sizes = mkOption {
      type = types.listOf types.ints.unsigned;
      description = "Sizes of shared memory devices";
      example = "[128 64]";
    };
    user = mkOption {
      type = types.str;
      description = "Owner of devices in /dev/kvmfr*. The user can open the device for rendering in LookingGlass client.";
      example = "jane";
    };
  };

  config = mkIf cfg.enable (
    let
      kvmfr = pkgs.callPackage ./kvmfr.nix { kernel = cfg.kernel; };
      sizesAsStringList = builtins.map builtins.toString cfg.sizes;
      deviceIdList = builtins.map builtins.toString (lib.range 0 (length cfg.sizes - 1));
      kvmfrDevices = builtins.map (x: "/dev/kvmfr${x}") deviceIdList;
      cgroupDeviceAcl = [
        "/dev/null"
        "/dev/full"
        "/dev/zero"
        "/dev/random"
        "/dev/urandom"
        "/dev/ptmx"
        "/dev/kvm"
      ] ++ kvmfrDevices;
    in
    {
      boot.kernelModules = [ "kvmfr" ];
      boot.extraModulePackages = [ kvmfr ];
      boot.extraModprobeConfig = ''
        options kvmfr static_size_mb=${lib.concatStringsSep "," sizesAsStringList}
      '';
      virtualisation.libvirtd.qemuVerbatimConfig = ''
        cgroup_device_acl = [${lib.concatMapStringsSep "," (x: "\"${x}\"") cgroupDeviceAcl}]
      '';
      systemd.services.set-kvmfr-user = {
        wantedBy = [ "multi-user.target" ];
        description = "Set the owners of kvmfr devices.";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          DEVS='${concatStringsSep " " kvmfrDevices}'
          for DEV in $DEVS; do
            chown ${cfg.user} "$DEV"
          done
        '';
      };
    }
  );
}
