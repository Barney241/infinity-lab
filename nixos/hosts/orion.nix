{ config, pkgs, ... }:
{
  imports = [
    ../common.nix
  ];
  networking.hostName = "orion";

  roles = {
    docker = {
      enable = true;
    };
    dev = {
      enable = true;
    };
    sway = {
      enable = true;
    };
    tailscale = {
      enable = true;
    };
  };
}
