{ config, lib, pkgs, ... }:
let
  slack = pkgs.slack.overrideAttrs (oldAttrs: rec {
    fixupPhase = ''
      sed -i -e 's/,"WebRTCPipeWireCapturer"/,"LebRTCPipeWireCapturer"/' $out/lib/slack/resources/app.asar

      rm $out/bin/slack
      makeWrapper $out/lib/slack/slack $out/bin/slack \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --suffix PATH : ${lib.makeBinPath [ pkgs.xdg-utils ]} \
        --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer"
    '';
  });
  postman = pkgs.postman.overrideAttrs (oldAttrs: rec {
    version = "20230716100528";
    src = pkgs.fetchurl {
      url = "https://web.archive.org/web/${version}/https://dl.pstmn.io/download/latest/linux_64";
      sha256 = "sha256-svk60K4pZh0qRdx9+5OUTu0xgGXMhqvQTGTcmqBOMq8=";

      name = "${oldAttrs.pname}-${version}.tar.gz";
    };
  });
in
{
  home.packages = [
    pkgs.libsForQt5.kdeconnect-kde

    #dev
    slack
    pkgs.dbeaver
    postman
    pkgs.vscode
    pkgs.jetbrains-toolbox
    pkgs.resp-app #redis client

    #social
    pkgs.caprine-bin
    pkgs.teamspeak5_client

    #browsers
    pkgs.google-chrome
    pkgs.chromium

    #media
    pkgs.vlc
    pkgs.spotify

    #system apps
    pkgs.notion-app-enhanced
    pkgs.bitwarden-cli
    pkgs.bitwarden
    pkgs.solaar #logitech
    pkgs.notion-app-enhanced
    pkgs.gnome.gnome-calculator
    pkgs.gnome.gnome-disk-utility
    pkgs.gnome.gnome-terminal
    pkgs.libreoffice
    pkgs.piper
    pkgs.polychromatic #razer

    #remote desktop
    pkgs.teamviewer
    pkgs.rustdesk
  ];

  services.blueman-applet.enable = true;
}
