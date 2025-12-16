{ config, lib, ... }:
let cfg = config.roles.netdata;
in {
  options.roles.netdata = {
    enable = lib.mkEnableOption "Netdata monitoring";
  };

  config = lib.mkIf cfg.enable {
    services.netdata = {
      enable = true;
      config = {
        global = {
          "memory mode" = "dbengine";
          "page cache size" = 32;
          "dbengine multihost disk space" = 256;
        };
      };
    };
    # Access via http://localhost:19999
  };
}
