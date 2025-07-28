{ config, pkgs, lib, zen-browser, ... }:
let
  cfg = config.roles.desktop;

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
  options.roles.desktop = { enable = lib.mkEnableOption "Enable desktop"; };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      slack

      #browsers
      pkgs.google-chrome
      pkgs.chromium
      zen-browser.default

      pkgs.ghostty

    ];
  };
}
