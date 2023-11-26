{ lib, config, pkgs, modulesPath, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  imports =
    [
      ./common.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/sda1";
      fsType = "ext4";
    };
    # "/boot" = {
    # device = "/dev/disk/by-label/sr0";
    # fsType = "vfat";
    # };
    # "/backup" = {
    # device = "/dev/disk/by-label/backup";
    # fsType = "ext4";
    # };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # swapDevices = [{ device = "/swapfile"; size = 16382; }];

  # gpus.nvidia.enable = true;
}
