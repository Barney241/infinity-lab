{ hyprland, config, pkgs, lib, ... }:
let
  cfg = config.hyprland;
in
{
  options.hyprland = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable
    {
      environment.systemPackages = with pkgs; [
        greetd.tuigreet
      ];
       services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
            user = "greeter";
          };
        };
      };
      programs.hyprland = {
        enable = true;
        package = hyprland.packages.${pkgs.system}.hyprland;
      };
      environment.sessionVariables.NIXOS_OZONE_WL = "1";
      environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

      environment.variables.GTK_THEME = "Catppuccin-Macchiato-Standard-Teal-Dark";
      environment.variables.XCURSOR_THEME = "Catppuccin-Macchiato-Teal";
    };
}

