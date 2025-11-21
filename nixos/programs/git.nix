{ config, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Pavel Adamek";
        email = "pavel.adamek241@gmail.com";
      };
    };
  };
}
