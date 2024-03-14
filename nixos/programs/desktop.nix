{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    libsForQt5.kdeconnect-kde
    slack
    dbeaver
    # postman
    caprine-bin
    resp-app
    notion-app-enhanced
    chromium
    bitwarden
    jetbrains-toolbox
    vscode
    spotify
    google-chrome
    teamspeak5_client
    solaar
    notion-app-enhanced
    gnome.gnome-calculator
    gnome.gnome-disk-utility
  ];

  services.blueman-applet.enable = true;
}
