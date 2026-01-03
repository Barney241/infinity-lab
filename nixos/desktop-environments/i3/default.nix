{ config, pkgs, lib, ... }:
let cfg = config.i3;
in {
  options.i3 = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [{
    environment.pathsToLink = [ "/libexec" ];

    environment.xfce.excludePackages = [ pkgs.xfce4-power-manager ];

    services.gvfs.enable = true;
    security.rtkit.enable = true;
    services.blueman.enable = false;

    services.libinput.mouse.middleEmulation =
      false; # this doesnt work needs xserver for now
    services.libinput.touchpad.middleEmulation = false;

    programs.dconf.enable = true;
    programs.thunar.enable = true;

    fonts.packages = with pkgs; [ nerd-fonts.fira-code ];

    services.xserver = {
      enable = true;

      xkb = {
        variant = "";
        layout = "us,cz";
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu # application launcher most people use
          i3status # gives you the default i3 status bar
          i3lock # default i3 screen locker
          i3blocks # if you are planning on using i3blocks over i3status
          feh
        ];
      };
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          # noDesktop = true;
          enableXfwm = false;
        };
      };
      displayManager = { lightdm.enable = true; };
    };

    services.displayManager = { defaultSession = "xfce+i3"; };

    systemd.user.services.polkit-kde-authentication-agent-1 = {
      description = "polkit-kde-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  }]);
}
