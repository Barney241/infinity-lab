{ config, pkgs, ... }:

{
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
  home.username = "barney";
  home.homeDirectory = "/home/barney";
  nixpkgs.config.allowUnfreePredicate = _: true;

  imports = [
    ../programs/nvim.nix
  ];
}
