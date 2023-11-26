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
      enable = true;
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
  };
}
