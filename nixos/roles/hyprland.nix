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
      i18n.inputMethod.enabled = "fcitx5";
      i18n.inputMethod.fcitx5.addons = [ pkgs.fcitx5-mozc ];

      security.pam.services.swaylock = { };

      services.udisks2 = {
        enable = true;
        mountOnMedia = true;
      };

      services.xserver = {
        enable = true;
        excludePackages = [ pkgs.xterm ];
      };

      services.xserver = {
        enable = true;

        desktopManager = {
          plasma5.enable = true;
        };

        displayManager = {
          sddm.enable = true;

          autoLogin = {
            enable = true;
            user = "barney";
          };
        };

        excludePackages = [ pkgs.xterm ];
      };

      systemd.services = {
        "getty@tty1".enable = false;
        "autovt@tty1".enable = false;
      };

      programs.hyprland.enable = true;
    };
}

