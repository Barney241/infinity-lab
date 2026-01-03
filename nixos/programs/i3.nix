{ lib, pkgs, ... }: {
  imports = [
    ./ghostty.nix
    ./audio.nix
    ./desktop.nix
    ./rofi.nix
    # ./polybar.nix
    ./firefox.nix
    ./himalaya.nix
    ./superfile.nix
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
    pkgs.kdePackages.kdeconnect-kde
    pkgs.waypipe
    pkgs.dconf
    pkgs.bash
    pkgs.alsa-utils
    pkgs.xfce4-screenshooter
    pkgs.xfce4-clipman-plugin
    pkgs.xfce4-notifyd
    pkgs.pavucontrol
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
    paths = let
      polybar-themes = pkgs.fetchFromGitHub {
        owner = "Barney241";
        repo = "polybar-themes";
        rev = "d40dad8d5fff5a50e0feb9771a0620da8335f2b6";
        sha256 = "sha256-G9ackTRlGjzccXNAhAtrxSnEk89jxEMBXC7kmDuxojw=";
      };
    in [ "${polybar-themes}/fonts" "${polybar-themes}/simple" ];
  };

  xsession.windowManager.i3 = {
    enable = true;

    config = rec {
      modifier = "Mod4";
      terminal = "ghostty";
      # bars = [ ];

      # window.border = 0;

      gaps = {
        # inner = 5;
        # outer = 0;
        smartGaps = true;
      };
      modes = {
        resize = {
          Left = "resize shrink width 10 px";
          Down = "resize grow height 10 px";
          Up = "resize shrink height 10 px";
          Right = "resize grow width 10 px";

          Escape = "mode default";
          Return = "mode default";
        };
      };

      window = { hideEdgeBorders = "smart"; };

      keybindings = lib.mkOptionDefault {
        "XF86AudioMute" = "exec amixer set Master toggle";
        "XF86AudioLowerVolume" = "exec amixer set Master 5%-";
        "XF86AudioRaiseVolume" = "exec amixer set Master 5%+";
        "${modifier}+Return" = "exec ${pkgs.ghostty}/bin/ghostty";

        # kill focused window
        "${modifier}+q" = "kill";

        # start your launcher
        "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -modi drun -show drun";
        "${modifier}+Shift+d" = "exec ${pkgs.rofi}/bin/rofi -show window";

        "${modifier}+Shift+V" = "exec xfce4-clipman-history";
        "${modifier}+Shift+P" = "exec xfce4-clipman-history";
        "${modifier}+Shift+S" = "exec pavucontrol";

        # reload the configuration file
        "${modifier}+Shift+c" = "reload";

        "${modifier}+Shift+e" = "exec xfce4-session-logout";

        "${modifier}+F12" = "exec shutdown now";
        "${modifier}+Shift+L" = "exec xflock4";
        "${modifier}+shift+return" = "exec thunar";
        "${modifier}+tab" = "workspace back_and_forth";

        "${modifier}+Control+Left" = "move workspace to output left";
        "${modifier}+Control+Right" = "move workspace to output right";
        #
        # Workspaces:
        #
        # switch to workspace
        "${modifier}+1" = "workspace 1";
        "${modifier}+2" = "workspace 2";
        "${modifier}+3" = "workspace 3";
        "${modifier}+4" = "workspace 4";
        "${modifier}+5" = "workspace 5";
        "${modifier}+6" = "workspace 6";
        "${modifier}+7" = "workspace 7";
        "${modifier}+8" = "workspace 8";
        "${modifier}+9" = "workspace 9";
        "${modifier}+0" = "workspace 10";
        # move focused container to workspace
        "${modifier}+Shift+1" = "move container to workspace 1";
        "${modifier}+Shift+2" = "move container to workspace 2";
        "${modifier}+Shift+3" = "move container to workspace 3";
        "${modifier}+Shift+4" = "move container to workspace 4";
        "${modifier}+Shift+5" = "move container to workspace 5";
        "${modifier}+Shift+6" = "move container to workspace 6";
        "${modifier}+Shift+7" = "move container to workspace 7";
        "${modifier}+Shift+8" = "move container to workspace 8";
        "${modifier}+Shift+9" = "move container to workspace 9";
        "${modifier}+Shift+0" = "move container to workspace 10";

        # Layout stuff:
        #
        # You can "split" the current object of your focus with
        # $mod+b or $mod+v, for horizontal and vertical splits
        # respectively.
        "${modifier}+b" = "splith";
        "${modifier}+v" = "splitv";
        "${modifier}+t" = "tabbed";

        # Switch the current container between different layout styles
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        # Make the current focus fullscreen
        "F11" = "fullscreen";
        "${modifier}+Shift+f" = "fullscreen";

        # Toggle the current focus between tiling and floating mode
        "${modifier}+Shift+space" = "floating toggle";

        # Swap focus between the tiling area and the floating area
        "${modifier}+Mod1+space" = "focus mode_toggle";

        # move focus to the parent container
        "${modifier}+a" = "focus parent";
        #
        # Scratchpad:
        #
        # Sway has a "scratchpad", which is a bag of holding for windows.
        # You can send windows there and get them back later.

        # Move the currently focused window to the scratchpad
        "${modifier}+Shift+minus" = "move scratchpad";

        # Show the next scratchpad window or hide the focused scratchpad window.
        # If there are multiple scratchpad windows, this command cycles through them.
        "${modifier}+minus" = "scratchpad show";
      };

      startup = [
        # browser
        # { command = "firefox"; }

        { command = "spotify"; }

        { command = "slack"; }

        {
          command = "ghostty";
        }

        # audio
        { command = "playerctld daemon"; }

        {
          command =
            "${pkgs.feh}/bin/feh --bg-scale --randomize ~/.config/wallpapers/*";
          always = true;
          notification = false;
        }
      ];
    };
  };
}
