{ config, pkgs, ... }:
{
  imports = [
    ../common.nix
  ];
  networking = {
    hostName = "serveros";
    firewall = {
        enable = true;
        allowPing = true;
        allowedUDPPortRanges = [
            {
                from = 0;
                to = 65535;
            }
        ];
        allowedTCPPortRanges = [
            {
                from = 0;
                to = 65535;
            }
        ];    
    };   
  };

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
      zig = true;
    };
    tailscale = {
      enable = true;
    };
    jupyter = {
      enable = true;
    };
    gaming = {
      enable = true;
    };


    # hyprland = {
    #   enable = true;
    # };
    # desktop = {
    #   enable = true;
    # };
    plasmaDesktop = {
      enable = true;
    };
  };
}
