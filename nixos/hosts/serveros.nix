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

    i3.enable = true;

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
            enable = false;
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
