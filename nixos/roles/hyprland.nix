{ config, pkgs, lib, ... }:
let
  cfg = config.roles.hyprland;
in
{
  options.roles.hyprland = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable
    {
      services.xserver.enable = true;
      services.xserver.desktopManager.plasma5.enable = true;

      environment.systemPackages = with pkgs; [
        greetd.tuigreet
      ];
      services.greetd = {
        enable = true;
        settings = {
          default_session.command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet \
              --time \
              --asterisks \
              --user-menu \
              --cmd Hyprland
          '';
        };
      };
      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      };
    };
}

