{ config, pkgs, lib, ... }:
let
  cfg = config.roles.xMinimalDesktop;
in
{
  options.roles.xMinimalDesktop = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable
    {
      security.rtkit.enable = true;

      services.xserver.enable = true;
      services.xserver.displayManager.sddm.enable = true;
      services.xserver.displayManager.sddm.wayland.enable = true;
      services.desktopManager.plasma6.enable = true;
      services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;
      };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        elisa
        # gwenview
        # okular
        oxygen
        khelpcenter
        konsole
        # plasma-browser-integration
        print-manager
      ];
    };
}
