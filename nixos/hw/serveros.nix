    { lib, pkgs, config, ... }:
{

  boot.loader = {
    efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi"; # ← use the same mount point here.
    };
    grub = {
        enable = true;
        efiSupport = true;
        devices = [ "nodev" ];
        useOSProber = true;
   };
  };

  imports =
    [
      ./common.nix
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  environment.systemPackages = [ pkgs.cifs-utils ];

  # needed for mounting to non-root users
  security.wrappers."mount.cifs" = {
      program = "mount.cifs";
      source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
      owner = "root";
      group = "root";
      setuid = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/308cf73f-3b53-4b5c-8874-78d4b3ff86c3";
      fsType = "ext4";
    };
    "/media" = {
        device="//192.168.18.122/media";
        fsType="cifs";
        options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      in ["${automount_opts},credentials=/home/barney/nas-serveros-secrets,uid=${toString config.users.users.docker.uid},gid=${toString config.users.groups.docker.gid}"];
    };
    "/disks/hdd_backup" = {
      device = "/dev/disk/by-uuid/e891b814-1ce9-4448-b979-f20f6ff0221e";
      fsType = "ext4";
    };
     "/efi" = {
       device = "/dev/disk/by-uuid/EBAD-07A2";
       fsType = "vfat";
    };
  };

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 16*1024; # in MiB
  } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
  # networking.interfaces.ens3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  gpus.nvidia.enable = true;

  hardware = {
    cpu.amd.updateMicrocode = true;
  };

  services = {
    xserver = {
      deviceSection = ''
        #Option "AsyncFlipSecondaries" "true"
        Option "TearFree" "true"
        Option "VariableRefresh" "true"
      '';
    };
  };
}
