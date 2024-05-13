{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
    ../programs/zsh.nix
    ../programs/git.nix
    ../programs/firefox.nix
    ../programs/alacritty.nix
    ../programs/desktop.nix
    # ../programs/sway.nix
    # ../programs/hyprland.nix
  ];

  home.file = {
    # Stable SDK symlinks
    "SDKs/Java/17".source = pkgs.jdk17.home;
    "SDKs/Java/11".source = pkgs.jdk11.home;
    "SDKs/Java/8".source = pkgs.jdk8.home;
  };
}
