{ config, lib, pkgs, ... }: {
  services.mako = {
    enable = true;
    settings = {
      sort = "-time";
      layer = "overlay";
      background-color = "#1f2530";
      width = 300;
      height = 110;
      border-size = 2;
      border-color = "#fb958b";
      border-radius = 15;
      icons = false;
      max-icon-size = 64;
      default-timeout = 5000;
      ignore-timeout = true;
      font = "monospace 12";
      markup = true;
    };
  };
}
