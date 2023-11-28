{ config, pkgs, lib, ... }: {
  imports = [
    ./desktop.nix
    ./dev.nix
    ./dns.nix
    ./docker.nix
    ./gaming.nix
    ./jupyter.nix
    ./netclient.nix
    ./tailscale.nix
    ./xMinimalDesktop.nix
    ./hyprland.nix
  ];
}
