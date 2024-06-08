{ config, pkgs, lib, ... }:
let
  cfg = config.sway;
in
{
  options.sway = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
    loginManager = lib.mkOption {
      default = true;
      example = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        security.rtkit.enable = true;
        security.pam.services.swaylock = { };
        sound.enable = true;

        programs.xwayland.enable = true;
        services.blueman.enable = true;
        programs.thunar.enable = true;

        fonts.packages = with pkgs; [
          nerdfonts
          fira-code-nerdfont
        ];

        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.systemPackages = [
          pkgs.whatsapp-for-linux
          pkgs.wayvnc
          pkgs.pavucontrol
          pkgs.blueberry
          pkgs.grim
          pkgs.swappy
          pkgs.slurp
          pkgs.libreoffice
          pkgs.wallutils

          pkgs.ledger-live-desktop # testing
          pkgs.yubioath-flutter # testing
          pkgs.pcsclite # testing
          pkgs.pulseaudio # testing
          pkgs.alsa-utils # testing
          pkgs.helvum # testing

          pkgs.obsidian # testing
          pkgs.appflowy # testing
          pkgs.floorp # testing
          pkgs.gnome.simple-scan # testing
          pkgs.affine # testing
        ];

        # security.pam.loginLimits = [
          # { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
        # ];

        services.udev.packages = [ pkgs.yubikey-personalization ]; # testing
        services.pcscd.enable = true; # testing
        services.avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
        }; # testing, mDNS, printing
        services.printing.enable = true; # testing
        hardware.sane.enable = true; # enables support for SANE scanners
        users.extraGroups.scanner.members = [ "barney" ];
        users.extraGroups.lp.members = [ "barney" ];


        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          wireplumber.enable = true;
          # jack.enable = true;
        };
        # testing network party audio
        # environment.etc = {
        #   "pipewire/pipewire-pulse.conf.d/50-network-party.conf".text = ''
        #     context.exec = [
        #         { path = "pactl" args = "load-module module-native-protocol-tcp" }
        #         { path = "pactl" args = "load-module module-zeroconf-discover" }
        #         { path = "pactl" args = "load-module module-zeroconf-publish" }
        #     ]
        #   '';
        # };
        # # airplay
        # environment.etc = {
        #   "pipewire/pipewire.conf.d/raop-discover.conf".text = ''
        #     context.modules = [
        #        {
        #            name = libpipewire-module-raop-discover
        #            args = { }
        #        }
        #     ]
        #   '';
        # };
        services.dbus.enable = true;

        xdg.portal = {
          enable = true;
          wlr.enable = true;
          wlr.settings = {
            screencast = {
              chooser_type = "simple";
              # works but doesn not allow choosing windows
              chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
            };
          };
          extraPortals = [
            pkgs.xdg-desktop-portal-gtk
          ];
          configPackages = [ pkgs.sway ];
        };

        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${cfg.desktop}";
              user = "greeter";
            };
          };
        };
        
        services.xserver = {
          videoDrivers = [ "nvidia" ];
          displayManager.gdm.wayland = true;
        };

        systemd.user.services.polkit-kde-authentication-agent-1 = {
          description = "polkit-kde-authentication-agent-1";
          wantedBy = [ "graphical-session.target" ];
          wants = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      }
    ]
  );
}
