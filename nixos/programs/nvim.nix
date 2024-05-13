{ config, lib, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
  };

  programs.neovim.plugins = [
    pkgs.vimPlugins.packer-nvim
  ];
}
