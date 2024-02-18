{ lib, config, pkgs, modulesPath, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "/dev/sda";
  #boot.loader.grub.useOSProber = true;

  imports =
    [
      ./common.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];


  boot.swraid ={
      enable=true;
      mdadmConf=''
ARRAY /dev/md/0 level=raid1 num-devices=2 metadata=1.2 name=serveros:0 UUID=8970de53:9de3073d:ed05029f:0f95ecc9
   devices=/dev/sdb1,/dev/sdc1
    '';
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/308cf73f-3b53-4b5c-8874-78d4b3ff86c3";
      fsType = "ext4";
    };
    "/media" = {
      device = "/dev/disk/by-uuid/06954c4a-6f63-413d-a607-82a491099466";
      fsType = "ext4";
    };
    "/disks/raid1" = {
      device = "/dev/disk/by-uuid/06954c4a-6f63-413d-a607-82a491099466";
      fsType = "ext4";
    };
    "/disks/hdd_backup" = {
      device = "/dev/disk/by-uuid/e891b814-1ce9-4448-b979-f20f6ff0221e";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/221C-E69A";
      fsType = "vfat";
    };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # swapDevices = [{ device = "/swapfile"; size = 16382; }];

 #gpus.nvidia.enable = true;
}
