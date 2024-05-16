{ config, pkgs,attrs, lib, ... }:
let
  cfg = config.roles.plasmaDesktop;
in
{
  options.roles.plasmaDesktop = {
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
          audio.enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
          pulse.enable = true;
          jack.enable = true;
          wireplumber = {
            enable = true;
          };
      };
      sound.enable = false;

      fonts.packages = with pkgs; [
          nerdfonts
      ];

    # services.xserver.enable = true;
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
      # services.desktopManager.plasma6.enable = true;
      #Wayland
      # services.displayManager.sddm.enable = true;
      # services.displayManager.sddm.wayland.enable = true;
      # services.xserver.displayManager.defaultSession = "plasma";
      # services.xserver.displayManager.sddm.wayland.enable = true;

      # services.xserver.displayManager.defaultSession = "plasmax11";

      # environment.plasma6.excludePackages = with pkgs.kdePackages; [
      #   elisa
      #   # gwenview
      #   okular
      #   oxygen
      #   khelpcenter
      #   konsole
      #   # plasma-browser-integration
      #   print-manager      
      #   ];


        
        environment = {
          plasma6.excludePackages = with pkgs.kdePackages; [ elisa ];
          sessionVariables = {
            GDK_DEBUG = "portals"; # KDE filepicker
            XDG_CURRENT_DESKTOP = "KDE";
          };
          systemPackages =
            with pkgs;
            with pkgs.kdePackages;
            [
              ffmpegthumbnailer
              colord-kde
              discover
              filelight
              ghostwriter
              k3b
              kate
              kcalc
              kcron
              kde-rounded-corners
              kdesu
              kdialog
              kio-extras
              kirigami-addons
              kjournald
              attrs.kwin-effects-forceblur.packages.${pkgs.system}.default
              neochat
              packagekit-qt # Discover store
              plasma-browser-integration
              qtimageformats
              qtstyleplugin-kvantum
              sddm-kcm
              syntax-highlighting
              tokodon
            ];
        };
        programs = {
          fuse.userAllowOther = true;
          kdeconnect.enable = true;
          partition-manager.enable = true;
        };
        services = {
          colord.enable = true;
          desktopManager.plasma6.enable = true;
          displayManager = {
            # Black screen on login if enabled with Wayland. https://github.com/NixOS/nixpkgs/issues/292980#issuecomment-1975380961
            #autoLogin = { user = "${username}"; };
            #defaultSession = "plasmax11";
            sddm = {
              enable = true;
              settings = {
                General = {
                  InputMethod = ""; # Remove virtual keyboard
                };
              };
              wayland = {
                enable = true;
                compositor = "kwin";
              };
            };
          };
          xserver = {
            enable = true;
            displayManager.setupCommands = ''
              ${pkgs.xorg.xhost}/bin/xhost +local:
            ''; # Distrobox games
            excludePackages = with pkgs; [ xterm ];
            libinput = {
              mouse.accelProfile = "flat";
              touchpad.accelProfile = "flat";
            };
            xkb = {
              layout = "us";
            };
          };
        };
        # https://github.com/NixOS/nixpkgs/issues/305119#issuecomment-2067970575
        systemd.user.services.nixos-rebuild-sycoca.enable = false;
        xdg = {
          portal = {
            config.common.default = "*";
            extraPortals = with pkgs; [
              kdePackages.xdg-desktop-portal-kde
              xdg-desktop-portal-gtk
            ];
            wlr.enable = true;
            xdgOpenUsePortal = true;
          };
        };
    };
}
