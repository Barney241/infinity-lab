# Common config shared among all machines
{ pkgs, attrs, lib, hostName, ... }: {
  system.stateVersion = "24.05";

  imports = [ 
    #System  
    ./components
    ./desktop-environments
  ];

  nixpkgs = {
    config = {
        allowUnfree = true;
        allowBroken = false;
        permittedInsecurePackages = [
          "electron-25.9.0"
        ];
    };
    overlays = [ attrs.nur.overlay ];
  };

  # Garbage collect & optimize /nix/store daily.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;
  nix.settings = {
    experimental-features = [ 
      "nix-command"
      "flakes" 
    ];
    auto-optimise-store = true;
    substituters = [
      "https://nyx.chaotic.cx"
      "https://cache.nixos.org"
      "https://hyprland.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    trusted-public-keys = [
      "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
  };

  # latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = hostName;
  networking.networkmanager.enable = lib.mkDefault true;
  services.resolved.enable = true;

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
    delta
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
  
  
  time.timeZone = "Europe/Prague";

  security.polkit.enable = true;
 
  users.mutableUsers = true;
  users.users.barney = {
    isNormalUser = true;
    home = "/home/barney";
    description = "barney";
    extraGroups = [ 
      "wheel"
      "gamemode"
    ];
    initialPassword = "test";
  };
  

  users.users.docker = {
    isSystemUser = true;
    uid=1001;
    group="wheel";
  };


  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  users.users.root.shell = pkgs.zsh;
  programs.zsh.enable = true;
  
  services.earlyoom.enable = true;

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
