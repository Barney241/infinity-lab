{ config, pkgs, lib, ... }:
let
  cfg = config.roles.pam;
in
{
  options.roles.pam = {
    enable = lib.mkOption {
      default = true;
      example = true;
      type = lib.types.bool;
      description = "Enable PAM authentication configuration";
    };

    fingerprint = {
      enable = lib.mkOption {
        default = false;
        example = true;
        type = lib.types.bool;
        description = "Enable fingerprint authentication via fprintd";
      };
    };
  };

  config = lib.mkMerge [
    # Base authentication configuration
    (lib.mkIf cfg.enable {
      # Basic security settings
      security.polkit.enable = lib.mkDefault true;

      # PAM base configuration
      security.pam.services = {
        login = { };
        sudo = { };
        swaylock = { };  # for sway screen lock
        i3lock = { };    # for i3 screen lock
        lightdm = { };   # for i3 display manager
        greetd = { };    # for sway display manager
        # cosmic-greeter is configured by services.desktopManager.cosmic
      };
    })

    # Fingerprint authentication configuration
    (lib.mkIf (cfg.enable && cfg.fingerprint.enable) {
      # Enable fprintd service
      services.fprintd.enable = true;

      # Configure PAM for fingerprint authentication with explicit "sufficient" rules
      # This means: try fingerprint first, if it succeeds -> done; if it fails -> try password
      # NOTE: Only enabled for screen locks (swaylock, i3lock) and sudo
      #       NOT enabled for login/sddm/lightdm - they don't handle fprintd blocking behavior well
      security.pam.services = {
        swaylock = {
          rules.auth.fprintd = {
            order = config.security.pam.services.swaylock.rules.auth.unix.order - 10;
            control = "sufficient";
            modulePath = "${pkgs.fprintd}/lib/security/pam_fprintd.so";
          };
        };
        i3lock = {
          rules.auth.fprintd = {
            order = config.security.pam.services.i3lock.rules.auth.unix.order - 10;
            control = "sufficient";
            modulePath = "${pkgs.fprintd}/lib/security/pam_fprintd.so";
          };
        };
        sudo = {
          rules.auth.fprintd = {
            order = config.security.pam.services.sudo.rules.auth.unix.order - 10;
            control = "sufficient";
            modulePath = "${pkgs.fprintd}/lib/security/pam_fprintd.so";
          };
        };
      };

      # Ensure fprintd starts on boot
      systemd.services.fprintd = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "dbus";
      };
    })
  ];
}
