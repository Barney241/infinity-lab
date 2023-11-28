{ config, pkgs, ... }:
{
  imports = [
    ../common.nix
  ];
  networking = {
    hostName = "serveros";
    firewall = {
      enable = false;
    };
  };

  roles = {
    docker = {
      enable = true;
    };
    dev = {
      enable = true;
    };
    xMinimalDesktop = {
      enable = false;
    };
    tailscale = {
      enable = true;
    };
    jupyter = {
      enable = false;
    };
    gaming = {
      enable = true;
    };
    hyprland = {
      enable = true;
    };
  };
}
