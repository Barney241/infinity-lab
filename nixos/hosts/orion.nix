{ config, pkgs, ... }: {
  imports = [ ../common.nix ];
  networking.hostName = "orion";

  sway.enable = true;

  roles = {
    desktop = { enable = true; };
    docker = { enable = true; };
    dev = {
      cli = true;
      gui = true;
    };
    lsp = {
      go = true;
      rust = true;
    };
    tailscale = { enable = true; };
    gaming = { enable = true; };
    pipewire = { enable = true; };
    ssh = { enable = true; };
    ios = { enable = true; };
  };
}
