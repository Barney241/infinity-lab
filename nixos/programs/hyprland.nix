{ config, lib, pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./audio.nix
    ./desktop.nix
    # ./mako.nix
    ./wofi.nix
    ./firefox.nix
  ];

  home.packages = with pkgs; [
    kanshi
    mako
    wallutils
    wl-clipboard
    libsForQt5.kdeconnect-kde
    wdisplays
    waypipe
  ];

  programs.hyprland = {
    enable = true;
  };

  programs.hyprland.xwayland = {
    hidpi = true;
    enable = true;
  };
}
