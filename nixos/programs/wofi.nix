{ config, lib, pkgs, ... }:
{
  programs.wofi = {
    enable = true;
    style = (builtins.readFile ./wofi/menu.css);
    settings = {
      width = 400;
      height = 250;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 20;
      gtk_dark = true;
    };
  };
}
