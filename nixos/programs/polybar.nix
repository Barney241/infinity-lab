{ pkgs,lib, ... }:
{
  services.polybar = {
    enable = true;

    script = ''
        PATH=${lib.makeBinPath [ 
            pkgs.bash
            pkgs.polybar
            pkgs.xorg.xrandr
            pkgs.toybox
        ]}

        if type "xrandr"; then
          for m in $(polybar -m | cut -d ':' -f 1); do
            MONITOR=$m polybar -q -r main -c ~/.config/polybar/colorblocks/config.ini &
          done
        else
            polybar -q -r main -c ~/.config/polybar/colorblocks/config.ini &
            # polybar --reload example &
        fi
    '';
  };
}
