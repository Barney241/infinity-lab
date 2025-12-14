{ config, pkgs, lib, ... }:
let cfg = config.roles.ai;
in {
  options.roles.ai = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      host = "0.0.0.0";
    };
    environment.systemPackages = with pkgs; [ ollama-cuda ];

  };
}
