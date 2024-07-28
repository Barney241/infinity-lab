{ config, pkgs, lib, ... }:
let
  cfg = config.gpus.amd;
in
{
  options.gpus.amd = {
    enable = lib.mkEnableOption "Enable amd gpu";
  };

  config = lib.mkIf cfg.enable
    {
      services.xserver.enable = true;
      services.xserver.videoDrivers = [ "amdgpu" ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      boot.initrd.kernelModules = [ "amdgpu" ];
      environment.systemPackages = [
        pkgs.amdgpu_top
        pkgs.rocmPackages.rocminfo
        pkgs.clinfo
      ];

      systemd.tmpfiles.rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ];
    };
}
