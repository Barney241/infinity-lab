# Common config shared among all machines
{ config, pkgs, hostName, environment, lib, catalog, ... }: {
  system.stateVersion = "24.05";

  imports = [ ./roles ];
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };
  # Garbage collect & optimize /nix/store daily.
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
  nix.optimise.automatic = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = hostName;
  # networking.networkmanager.enable = lib.mkDefault true;
  # services.resolved.enable = true;

  environment.systemPackages = with pkgs;[
    iwd
    git
    tmux
    tmux-sessionizer
    htop
    jq
    neovim-unwrapped
    tree
    wget
    curl
    lazydocker
    lazygit
    gcc
    unzip
    ripgrep
    fwupd
    pciutils
    nfs-utils
    mdadm
    spaceship-prompt
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  # TODO 
  # services.getty.helpLine =
  #   ">>> Flake node: ${hostName}, environment: ${environment}";

  programs.mosh.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    allowSFTP = true;
  };
  programs.ssh.startAgent = true;


  time.timeZone = "Europe/Prague";

  security.polkit.enable = true;


  users.mutableUsers = true;
  users.users.barney = {
    isNormalUser = true;
    home = "/home/barney";
    description = "barney";
    extraGroups = [ "wheel" ];
    initialPassword = "test";
  };
  users.users.barney.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvIiTTgyGGBVlYUgbAzdViyVYm38mKFfjL7YnmHwND5yDnoSZ12xCoM/pnZxT3/rT5iGRYaFeS6aLKX3ePLD9xfnbGHG2JeQWPGK9cavSJEs0WLa9MGXvsBlPWSSJeYp5B8rhd0B8jDIA6CILoyDhnDQ2ulVB6c6OQYThf2zG1IX+AclWjomQ4tAzDpsPX8MnP1OLXfrgUfY2xmeLFQxJU7n+xv+LRHXKyAhHUZrGTzQ5CxFnwEmWSMU5VXyO66Oh8v4GOGfFXrJzQKVddpfpl7iOAVkD+kZeq2loqwhZQFOF210j5k+pppuL0FZUONJlsbw/j+xuxMgE0BZA0ekXH1aUjAmbZjoPeyAAqldMx0eF8OVUlIpC2cSfOQaJOiQUjushfcqLPlOwr09Eq1ZES3Whs/I0RXLt0tIBDRGSVpPew07keRAL1AVqlCKMboZUVASacRAEOn4s4K6XCY0QcVBA7PKSErXOXcHyQpkZPRXpBBmagQoXKVZaEz8DrXLU= barney@BarneyLaptop"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCHGmpOxOGR9i3CVE1WMT9hudFQ0nlMR32kGazAQGfcOUu7CH49Au6jC8Yj0q11NwmWJba9Osda9xT6VbjQoCDNcfNutCGHtf1WWgl2VKV91tTyeQ4fxjJsN1pAVkqm37l9qyvK8yLRYzyTmrCpf2lFmHCTB5IsQm0K8Us/0uTccbX1jt0d35VjIfJnwmFbEClQZbD9dOfrAPUVvcSHmw9yrsBYFsxdB1kfXoZwqkOs7uoHBSB+MKXX08u5QiFS9c16arTbA5sOk/0wcdC/1nWYj7ymZ7Co0LD90fwMlApSN3bv3AUcJ9Qxu2OoeHbkSleUy1WqxZw+azakIm/vLCZv rsa-key-20220115"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDR0Py0dNvD/DkIpHPXMav6Hmg5xix7dkOG4ztP3BqgSnmq8ebioeDBWIDxRIGBUk69RE1TVJ+iVs60l8M58FtVJiMDbuX0R3JgRJNkCaiwmMTlD3IYin/fAqSk/seQGNj4R7YbT8rNLGhzdRcf1ww76t3w6JlfDfER1lSayS4WjxU4s8m3lCi7r8BdwDp8aOnmaU3vlrwne7/OW/ZQD7oHik4IA9f2zFFVQA/PTWmaQuYtxn1SLPRSRon+Gk6G4lULJ9bFFft9qTscZ8DuyCjQS5uA0F+SSJZRspRRDT+BAIesg2Zx2+HrajA1Y7/2NOsuhWAPpK6e/k8fsB8rqbyD pavel@LAPTOP-30GSN6DN"
  ];

  users.users.docker = {
    isSystemUser = true;
    uid=1001;
    group="wheel";
  };


  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  users.users.root.shell = pkgs.zsh;
  programs.zsh.enable = true;
  systemd.oomd.enable = true;
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  # disk automount
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.fwupd.enable = true;

  # age.secrets = {
  #   influxdb-telegraf.file = ./secrets/influxdb-telegraf.age;
  #   tailscale.file = ./secrets/tailscale.age;
  # };

  # environment.etc."issue.d/ip.issue".text = ''
  #   IPv4: \4
  # '';
  # networking.dhcpcd.runHook = "${pkgs.utillinux}/bin/agetty --reload";

}
