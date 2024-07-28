{ config, pkgs, lib, ... }:
let
  cfg = config.roles.pipewire;
in
{
  options.roles.pipewire = {
    enable = lib.mkOption {
      default = true;
      example = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable
    {
      services.pipewire = {
          enable = true;
          audio.enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
          pulse.enable = true;
          jack.enable = true;
          wireplumber = {
            enable = true;
          };
      };
   };
}
