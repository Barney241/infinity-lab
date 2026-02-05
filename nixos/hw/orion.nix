{ lib, pkgs, modulesPath, ... }: {
  hardware.firmware = [ pkgs.sof-firmware ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  imports =
    [ ./common.nix ./bluetooth.nix (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3b57e037-e2e3-4ae6-b79a-fb41e84a7fc9";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/90E3-8BD1";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024; # in MiB
  }];

  # auto-cpufreq moved to roles.auto-cpufreq (disabled for COSMIC)

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.ens3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
