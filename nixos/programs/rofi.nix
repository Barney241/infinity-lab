{  pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    theme = "~/.config/polybar/colorblocks/scripts/rofi/launcher.rasi";
    terminal = "${pkgs.alacritty}/bin/alacritty";
  };
}
