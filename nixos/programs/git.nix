{ config, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      user = {
        name = "Pavel Adamek";
        email = "pavel.adamek241@gmail.com";
      };
    };
  };
}
