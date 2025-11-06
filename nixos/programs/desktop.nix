{ pkgs, ... }: {
  home.packages = [
    # pkgs.kdePackages.kdeconnect-kde

    #dev
    pkgs.postman
    pkgs.vscode
    # pkgs.jetbrains-toolbox
    pkgs.resp-app # redis client

    #social
    pkgs.wasistlos
    pkgs.caprine-bin
    pkgs.teamspeak6-client

    #media
    pkgs.vlc
    pkgs.spotify

    #system apps
    pkgs.bitwarden-cli
    pkgs.bitwarden-desktop
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
