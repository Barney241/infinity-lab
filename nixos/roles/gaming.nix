{ config, pkgs, lib, ... }:
let
  cfg = config.roles.gaming;
in
{
  options.roles.gaming = {
    enable = lib.mkEnableOption "Enable gaming tools";
    customStart = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.libnotify}/bin/notify-send -t 3000 -u low 'GameMode' 'GameMode started' --icon=applications-games --app-name='GameMode'";
    };
    customStop = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.libnotify}/bin/notify-send -t 3000 -u low 'GameMode' 'GameMode stopped' --icon=applications-games --app-name='GameMode'";
    };
  };

  config = lib.mkIf cfg.enable
    {
      environment.systemPackages = with pkgs;[
        steam
        steam-run
        lutris
        prismlauncher
        xorg.xinput
        (lutris.override {
          extraPkgs = pkgs: [
            # List package dependencies here
            wineWowPackages.stable
            winetricks
          ];
        })
        wine
        wineWowPackages.staging
        winetricks
        wineWowPackages.waylandFull
        vkd3d
        vkdt-wayland
        dxvk
        q4wine # testing
        bottles # testing
      ];

      programs.gamescope = {
          enable = true;
          package = pkgs.gamescope_git; # Chaotic package
          capSysNice = true;
      };

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        gamescopeSession.enable = true;
        localNetworkGameTransfers.openFirewall = true;
      };

      programs.gamemode = {
          enable = true;
          settings = {
            general = {
              desiredgov = "performance";
              inhibit_screensaver = 1;
            };
            custom = {
              start = cfg.customStart;
              stop = cfg.customStop;
            };
          };
      };
      users = {
        groups.gamemode = { };
      };
    };
}
