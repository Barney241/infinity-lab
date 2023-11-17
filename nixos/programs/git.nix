{ config, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Pavel Adamek";
    userEmail = "pavel.adamek241@gmail.com";
  };
}
