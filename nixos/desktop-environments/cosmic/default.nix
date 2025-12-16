{ config, pkgs, lib, ... }:
let
  cfg = config.cosmic;
in
{
  options.cosmic = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
      description = "Enable the COSMIC desktop environment";
    };

    loginManager = lib.mkOption {
      default = true;
      example = false;
      type = lib.types.bool;
      description = "Enable cosmic-greeter login manager";
    };

    enableScheduler = lib.mkOption {
      default = true;
      example = false;
      type = lib.types.bool;
      description = "Enable system76-scheduler for improved performance";
    };

    enableDataControl = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
      description = "Enable clipboard access for all windows (security trade-off)";
    };

    autoLogin = {
      enable = lib.mkOption {
        default = false;
        example = true;
        type = lib.types.bool;
        description = "Enable automatic login";
      };
      user = lib.mkOption {
        default = null;
        example = "barney";
        type = lib.types.nullOr lib.types.str;
        description = "User to automatically log in";
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      # Enable the COSMIC desktop environment
      # This automatically enables: xdg.portal, dconf, polkit, rtkit, accounts-daemon,
      # libinput, upower, geoclue2, and sets defaults for bluetooth, networkmanager,
      # acpid, avahi, gnome-keyring, gvfs, orca, power-profiles-daemon
      services.desktopManager.cosmic.enable = true;

      # Disable power-profiles-daemon if auto-cpufreq is enabled (they conflict)
      services.power-profiles-daemon.enable = lib.mkForce (!config.services.auto-cpufreq.enable);

      # Common Wayland settings
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      # Audio is handled by roles.pipewire component

      fonts.packages = with pkgs; [ nerd-fonts.fira-code ];

      # Additional useful packages
      environment.systemPackages = with pkgs; [
        pavucontrol
        grim
        slurp
        wallutils
        helvum
      ];

      # Printing support
      services.printing.enable = true;

      # Firefox theming fix - disable libadwaita to allow COSMIC theme
      programs.firefox.preferences = {
        "widget.gtk.libadwaita-colors.enabled" = false;
      };
    }

    # Enable the COSMIC login manager
    (lib.mkIf cfg.loginManager {
      services.displayManager.cosmic-greeter.enable = true;
    })

    # Performance optimization
    (lib.mkIf cfg.enableScheduler {
      services.system76-scheduler.enable = true;
    })

    # Clipboard manager support (security trade-off)
    (lib.mkIf cfg.enableDataControl {
      environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = "1";
    })

    # Auto login configuration
    (lib.mkIf (cfg.autoLogin.enable && cfg.autoLogin.user != null) {
      services.displayManager.autoLogin = {
        enable = true;
        user = cfg.autoLogin.user;
      };
    })
  ]);
}
