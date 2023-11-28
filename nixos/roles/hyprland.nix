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
      programs.hyprland = {
        enable = true;
      };

      programs.hyprland.xwayland = {
        hidpi = true;
        enable = true;
      };
    };
}
