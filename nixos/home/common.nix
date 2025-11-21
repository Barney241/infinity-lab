{ config, pkgs, ... }:

{
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
  home.username = "barney";
  home.homeDirectory = "/home/barney";

  home = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        NIXPKGS_ALLOW_UNFREE = "1";
        WLR_NO_HARDWARE_CURSOR = "1";
      };
  };
  nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
  };
  xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        templates = null;
        publicShare = null;
      };
  };


  imports = [
    ../programs/nvim.nix
  ];
}
