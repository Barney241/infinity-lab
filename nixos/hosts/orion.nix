{ config, pkgs, ... }:
{
  imports = [
    ../common.nix
  ];
  networking.hostName = "orion";

  hyprland.enable = true;

  roles = {
    docker = {
      enable = true;
    };
    dev = {
      enable = true;
    };
    lsp = {
        go = true;
        rust = true;
        zig = false;
    };
    tailscale = {
        enable = true;
    };
    gaming = {
        enable = true;
    };
    pipewire = {
        enable = true;
    };
    ssh = {
        enable = true;
    };
  };
}
