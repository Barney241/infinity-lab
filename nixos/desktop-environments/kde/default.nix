{ config, pkgs, attrs, lib, ... }:
let cfg = config.kde;
in {
  options.kde = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;
    services.teamviewer.enable = true;
    services.ratbagd.enable = true;

    fonts.packages = with pkgs; [ nerd-fonts.fira-code ];

    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    # services.displayManager.sddm.wayland.enable = true;

    #Plasma 6
    services.desktopManager.plasma6.enable = true;
    #Wayland
    # services.displayManager.sddm.enable = true;
    # services.displayManager.sddm.wayland.enable = true;
    # services.xserver.displayManager.defaultSession = "plasma";
    # services.xserver.displayManager.sddm.wayland.enable = true;

    # services.xserver.displayManager.defaultSession = "plasmax11";

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      # gwenview
      okular
      oxygen
      # plasma-browser-integration
      print-manager
      spectacle # broken as of now
    ];

    # environment = {
    #   plasma6.excludePackages = with pkgs.kdePackages; [ 
    #     elisa
    #     spectacle   # broken as of now
    #   ];
    #   sessionVariables = {
    #     GDK_DEBUG = "portals"; # KDE filepicker
    #     XDG_CURRENT_DESKTOP = "KDE";
    #   };
    #   systemPackages =
    #     with pkgs;
    #     with pkgs.kdePackages;
    #     [
    #       ffmpegthumbnailer
    #       colord-kde
    #       discover
    #       filelight
    #       ghostwriter
    #       k3b
    #       kate
    #       kcalc
    #       kcron
    #       kde-rounded-corners
    #       kdesu
    #       kdialog
    #       kio-extras
    #       kirigami-addons
    #       kjournald
    #       attrs.kwin-effects-forceblur.packages.${pkgs.system}.default
    #       neochat
    #       packagekit-qt # Discover store
    #       plasma-browser-integration
    #       qtimageformats
    #       qtstyleplugin-kvantum
    #       sddm-kcm
    #       syntax-highlighting
    #       tokodon
    #     ];
    # };
    # programs = {
    #   fuse.userAllowOther = true;
    #   kdeconnect.enable = true;
    #   partition-manager.enable = true;
    # };
    # services = {
    #   colord.enable = true;
    #   desktopManager.plasma6.enable = true;
    #   displayManager = {
    #     # Black screen on login if enabled with Wayland. https://github.com/NixOS/nixpkgs/issues/292980#issuecomment-1975380961
    #     #autoLogin = { user = "${username}"; };
    #     #defaultSession = "plasmax11";
    #     sddm = {
    #       enable = true;
    #       settings = {
    #         General = {
    #           InputMethod = ""; # Remove virtual keyboard
    #         };
    #       };
    #       wayland = {
    #         enable = true;
    #         # compositor = "kwin"; # trying to fix
    #       };
    #     };
    #   };
    #   xserver = {
    #     enable = true;
    #     displayManager.setupCommands = ''
    #       ${pkgs.xorg.xhost}/bin/xhost +local:
    #     ''; # Distrobox games
    #     excludePackages = with pkgs; [ xterm ];
    #     libinput = {
    #       mouse.accelProfile = "flat";
    #     };
    #     xkb = {
    #       layout = "us";
    #     };
    #   };
    # };
    # # https://github.com/NixOS/nixpkgs/issues/305119#issuecomment-2067970575
    # systemd.user.services.nixos-rebuild-sycoca.enable = false;
    # xdg = {
    #   portal = {
    #     config.common.default = "*";
    #     extraPortals = with pkgs; [
    #       kdePackages.xdg-desktop-portal-kde
    #       xdg-desktop-portal-gtk
    #     ];
    #     wlr.enable = true;
    #     xdgOpenUsePortal = true;
    #   };
    # };
  };
}
