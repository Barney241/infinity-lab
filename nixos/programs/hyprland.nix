{ config, lib, pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./audio.nix
    ./desktop.nix
    # ./mako.nix
    ./wofi.nix
    # browser is managed by browser.nix imported from host configs
  ];

  home.packages = with pkgs; [
    kanshi
    mako
    wallutils
    wl-clipboard
    kdePackages.kdeconnect-kde
    wdisplays
    waypipe

    hyprpicker
    hyphen
  ];
}
