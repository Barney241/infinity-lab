{ config, pkgs, lib, ... }: {
  imports = [
    ./desktop.nix
    ./dev.nix
    # ./dns.nix
    ./docker.nix
    ./gaming.nix
    ./lsp.nix
    ./jupyter.nix
    ./netclient.nix
    ./tailscale.nix
    ./plasmaDesktop.nix
    ./hyprland.nix
    ./pipewire.nix
    ./ssh.nix
  ];
}
