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
    desktop = {
      enable = true;
    };
    tailscale = {
      enable = true;
    };
  };
}
