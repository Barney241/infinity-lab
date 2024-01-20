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
  ];

  services.blueman-applet.enable = true;
}
