{ config, lib, ... }:
let cfg = config.roles.suricata;
in {
  options.roles.suricata = {
    enable = lib.mkEnableOption "Suricata NIDS/IPS";
    interface = lib.mkOption {
      type = lib.types.str;
      default = "enp86s0";
      description = "Network interface to monitor";
    };
  };

  config = lib.mkIf cfg.enable {
    services.suricata = {
      enable = true;
      settings = {
        af-packet = [{
          interface = cfg.interface;
        }];
      };
    };
  };
}
