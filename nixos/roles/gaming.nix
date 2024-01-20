{ config, pkgs, lib, ... }:
let
  cfg = config.roles.gaming;
in
{
  options.roles.gaming = {
    enable = lib.mkEnableOption "Enable gaming tools";
  };

  config = lib.mkIf cfg.enable
    {
      environment.systemPackages = with pkgs;[
        steam
        steam-run
        lutris
        gamescope
        prismlauncher
        xorg.xinput
        (lutris.override {
          extraPkgs = pkgs: [
            # List package dependencies here
            wineWowPackages.stable
            winetricks
          ];
        })
      ];

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      };
    };
}
