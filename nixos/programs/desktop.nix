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
    # pkgs.libsForQt5.bismuthpro
    slack
    pkgs.dbeaver
    postman
    pkgs.caprine-bin
    pkgs.resp-app
    pkgs.notion-app-enhanced
    pkgs.chromium
    pkgs.bitwarden
    pkgs.jetbrains-toolbox
    pkgs.vscode
    pkgs.spotify
    pkgs.google-chrome
    pkgs.teamspeak5_client
    pkgs.solaar
    pkgs.notion-app-enhanced
    pkgs.gnome.gnome-calculator
    pkgs.gnome.gnome-disk-utility
    pkgs.libreoffice
    pkgs.piper
    pkgs.polychromatic
    pkgs.teamviewer
    # pkgs.rustdesk
  ];

  services.blueman-applet.enable = true;
}
