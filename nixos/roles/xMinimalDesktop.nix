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
      services.teamviewer.enable = true;
      services.ratbagd.enable = true;

      services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;
      };

      fonts.packages = with pkgs; [
          nerdfonts
      ];

    services.xserver.enable = true;
    # services.xserver.displayManager.sddm.enable = true;
    #Plasma 5
      # services.xserver.displayManager.sddm.wayland.enable = true;
      # services.xserver.desktopManager.plasma5.enable = true;
      # services.xserver.displayManager.defaultSession = "plasmawayland";

     # environment.plasma5.excludePackages = with pkgs.libsForQt5; [
      #   elisa
      #   # gwenview
      #   okular
      #   oxygen
      #   khelpcenter
      #   konsole
      #   # plasma-browser-integration
      #   print-manager
      # ];

    #Plasma 6
      services.desktopManager.plasma6.enable = true;
      #Wayland
      services.displayManager.sddm.enable = true;
      # services.displayManager.sddm.wayland.enable = true;
      # services.xserver.displayManager.defaultSession = "plasma";
      # services.xserver.displayManager.sddm.wayland.enable = true;

      services.xserver.displayManager.defaultSession = "plasmax11";

      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        elisa
        # gwenview
        okular
        oxygen
        khelpcenter
        konsole
        # plasma-browser-integration
        print-manager      
        ];
    };
}
