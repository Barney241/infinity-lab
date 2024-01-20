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
    # neovim
    # neovim-unwrapped
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
      PermitRootLogin = "yes";
    };
  };


  time.timeZone = "Europe/Prague";

  security.polkit.enable = true;

  users.mutableUsers = false;
  users.users.barney = {
    isNormalUser = true;
    home = "/home/barney";
    description = "barney";
    extraGroups = [ "wheel" ];
    initialPassword = "test";
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
