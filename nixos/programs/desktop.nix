{ pkgs, ... }: {
  home.packages = [
    # pkgs.kdePackages.kdeconnect-kde

    #dev
    pkgs.postman
    pkgs.vscode
    # pkgs.jetbrains-toolbox
    pkgs.resp-app # redis client

    #social
    pkgs.caprine-bin
    pkgs.teamspeak5_client

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
