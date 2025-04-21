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
in {
  home.packages = [
    pkgs.libsForQt5.kdeconnect-kde

    #dev
    slack
    pkgs.dbeaver-bin
    pkgs.postman
    pkgs.vscode
    # pkgs.jetbrains-toolbox
    pkgs.resp-app # redis client
    pkgs.ghostty

    #social
    pkgs.caprine-bin
    pkgs.teamspeak5_client
    pkgs.teamspeak3

    #browsers
    pkgs.google-chrome
    pkgs.chromium

    #media
    pkgs.vlc
    pkgs.spotify

    #system apps
    pkgs.bitwarden-cli
    pkgs.bitwarden
    pkgs.solaar # logitech
    pkgs.gnome-calculator
    pkgs.gnome-disk-utility
    pkgs.gnome-terminal
    pkgs.libreoffice
    pkgs.piper
    # pkgs.polychromatic #razer

    #remote desktop
    pkgs.teamviewer
    # pkgs.rustdesk #not working atm
  ];

  # services.blueman-applet.enable = true;
}
