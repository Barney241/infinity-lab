{  lib, pkgs, ... }:
{
    imports = [
        ./alacritty.nix
        ./desktop.nix
        ./rofi.nix
        # ./polybar.nix
        ./firefox.nix
    ];

    home.file.".config/wallpapers".source = (pkgs.fetchFromGitHub {
        owner = "Barney241";
        repo = "desktop-wallpapers";
        rev = "a2075354eef856bbf1f507de44504d1a5cbb01c4";
        hash = "sha256-avBC0jiXfInhH9avVcyKtNQudXeP7THJkw9QpnBONbA=";
    });

    home.packages = [
        pkgs.dbus # make dbus-update-activation-environment available in the path
        pkgs.kanshi
        pkgs.mako
        pkgs.wallutils
        pkgs.wl-clipboard
        pkgs.libsForQt5.kdeconnect-kde
        pkgs.waypipe
        pkgs.dconf
        pkgs.bash
    ];

    home.sessionVariables = {
        XDG_CURRENT_DESKTOP = "i3";
        WLR_NO_HARDWARE_CURSORS = "1";
    };
    services.cliphist.enable = true;

    gtk = {
        enable = true;
        cursorTheme = {
          name = "Vanilla-DMZ";
          package = pkgs.vanilla-dmz;
        };
        theme = {
          name = "Catppuccin-Macchiato-Compact-Pink-Dark";
          package = pkgs.catppuccin-gtk.override {
            accents = [ "pink" ];
            size = "compact";
            tweaks = [ "rimless" "black" ];
            variant = "macchiato";
          };
        };
    };

    xdg.configFile."polybar".source = pkgs.symlinkJoin {
      name = "polybar-symlinks";
      paths =
        let
          polybar-themes = pkgs.fetchFromGitHub {
            owner = "Barney241";
            repo = "polybar-themes";
            rev = "1e387422b95a9107f2346b8c774d92c62fe793a4";
            sha256 = "sha256-M5GjdqqgiZSVCDnl4Oln5KOxosY17Oe7Ggc9Kt9JFwI=";
          };
        in
        [
          "${polybar-themes}/fonts"
          "${polybar-themes}/simple"
        ];
    };

    xsession.windowManager.i3 = {
        enable = true;

        config = rec {
            modifier = "Mod4";
            # bars = [ ];

            # window.border = 0;

            gaps = {
                inner = 7;
                outer = 2;
            };

            keybindings = lib.mkOptionDefault {
                # "XF86AudioMute" = "exec amixer set Master toggle";
                # "XF86AudioLowerVolume" = "exec amixer set Master 4%-";
                # "XF86AudioRaiseVolume" = "exec amixer set Master 4%+";
                "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
                "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -modi drun -show drun";
                "${modifier}+Shift+d" = "exec ${pkgs.rofi}/bin/rofi -show window";
                "${modifier}+Shift+x" = "exec systemctl suspend";
            };

            startup = [
                {
                  command = "exec i3-msg workspace 1";
                  always = true;
                  notification = false;
                }
                # {
                #   command = "systemctl --user restart polybar.service";
                #   always = true;
                #   notification = false;
                # }
                {
                  command = "${pkgs.feh}/bin/feh --bg-scale --randomize ~/.config/wallpapers/*";
                  always = true;
                  notification = false;
                }
            ];
        };
    };
}
