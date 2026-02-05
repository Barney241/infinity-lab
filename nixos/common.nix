# Common config shared among all machines
{ config, pkgs, attrs, lib, hostName, ... }:
let
  nix-update = pkgs.writeShellScriptBin "nix-update" ''
    set -euo pipefail

    FLAKE_DIR="/home/barney/Projects/infinity-lab"
    HOST=$(${pkgs.hostname}/bin/hostname)

    # Colors for output
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'

    log_info() { echo -e "''${BLUE}[INFO]''${NC} $1"; }
    log_success() { echo -e "''${GREEN}[SUCCESS]''${NC} $1"; }
    log_warn() { echo -e "''${YELLOW}[WARN]''${NC} $1"; }
    log_error() { echo -e "''${RED}[ERROR]''${NC} $1"; }

    echo -e "''${BLUE}============================================''${NC}"
    echo -e "''${BLUE}  NixOS Update Script - Host: ''${GREEN}$HOST''${NC}"
    echo -e "''${BLUE}============================================''${NC}"
    echo ""

    # Step 1: Update flake inputs
    log_info "Updating flake inputs..."
    cd "$FLAKE_DIR"
    ${pkgs.nix}/bin/nix flake update
    log_success "Flake inputs updated"
    echo ""

    # Step 2: Rebuild NixOS
    log_info "Rebuilding NixOS for host: $HOST..."
    sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake "$FLAKE_DIR#$HOST"
    log_success "NixOS rebuilt successfully"
    echo ""

    # Step 3: Clean nix cache
    log_info "Cleaning nix store (garbage collection)..."
    sudo ${pkgs.nix}/bin/nix-collect-garbage -d
    log_success "Nix garbage collection complete"
    echo ""

    # Step 4: Optimize nix store
    log_info "Optimizing nix store..."
    sudo ${pkgs.nix}/bin/nix store optimise
    log_success "Nix store optimized"
    echo ""

    # Step 5: Update firmware
    log_info "Checking for firmware updates..."
    if command -v fwupdmgr &> /dev/null; then
        ${pkgs.fwupd}/bin/fwupdmgr refresh --force 2>/dev/null || log_warn "Could not refresh firmware metadata"
        ${pkgs.fwupd}/bin/fwupdmgr get-updates 2>/dev/null || log_info "No firmware updates available"
        ${pkgs.fwupd}/bin/fwupdmgr update -y 2>/dev/null || log_info "Firmware update complete (or no updates needed)"
        log_success "Firmware check complete"
    else
        log_warn "fwupdmgr not found, skipping firmware updates"
    fi
    echo ""

    echo -e "''${GREEN}============================================''${NC}"
    echo -e "''${GREEN}  Update complete for: $HOST''${NC}"
    echo -e "''${GREEN}============================================''${NC}"
  '';
in {
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
      permittedInsecurePackages = [ "electron-25.9.0" "electron-35.7.5" ];
    };
    overlays = [
      attrs.nur.overlays.default
      # Disable CUDA for onnxruntime to use cached builds (gamescope doesn't need GPU inference)
      (final: prev: {
        onnxruntime = prev.onnxruntime.override { cudaSupport = false; };
      })
    ];
  };

  # Garbage collect & optimize /nix/store daily.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.optimise.automatic = true;

  # zram swap (memory compression)
  zramSwap.enable = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    substituters = [
      "https://nyx.chaotic.cx"
      "https://cache.nixos.org"
      "https://cache.numtide.com"
      "https://hyprland.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  # latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = hostName;
  networking.networkmanager.enable = lib.mkDefault true;
  services.resolved.enable = true;

  environment.systemPackages = [
    nix-update
  ] ++ (with pkgs; [
    iwd
    git
    tmux
    # tmux-sessionizer #testing my own
    htop
    btop
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
    zip
    sshfs
    ripgrep
    fwupd
    pciutils
    nfs-utils
    mdadm
    spaceship-prompt
  ]);

  environment.sessionVariables = { EDITOR = "nvim"; };

  time.timeZone = "Europe/Prague";

  security.polkit.enable = true;

  users.mutableUsers = true;
  users.users.barney = {
    isNormalUser = true;
    home = "/home/barney";
    description = "barney";
    extraGroups = [ "wheel" "gamemode" "audio" ];
    hashedPasswordFile = config.age.secrets.barney-password.path;
  };

  users.users.docker = {
    isSystemUser = true;
    uid = 1001;
    group = "wheel";
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

  services.libinput.mouse.middleEmulation = false;

  services.glances = {
    enable = true;
    openFirewall = true;
    extraArgs = [
      "-w"                           # Enable web server mode
      "--time" "5"                   # Update every 5 seconds instead of 1
      "--disable-plugin" "docker"    # Disable docker plugin
      "--disable-plugin" "containers"
      "--disable-plugin" "gpu"
    ];
  };

  # age.secrets = {
  #   influxdb-telegraf.file = ./secrets/influxdb-telegraf.age;
  #   tailscale.file = ./secrets/tailscale.age;
  # };

  # environment.etc."issue.d/ip.issue".text = ''
  #   IPv4: \4
  # '';
  # networking.dhcpcd.runHook = "${pkgs.utillinux}/bin/agetty --reload";

}
