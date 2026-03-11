{ config, lib, ... }:
let cfg = config.roles.autosuspend;
in {
  options.roles.autosuspend = {
    enable = lib.mkEnableOption "autosuspend idle suspend daemon";
  };

  config = lib.mkIf cfg.enable {
    services.autosuspend = {
      enable = true;
      settings = {
        interval = 60;        # check every 60 seconds
        idle_time = 900;      # suspend after 15 minutes of inactivity
        suspend_cmd = "systemctl suspend";
      };
      checks = {
        # Keep awake if any user is logged in (including i3 session)
        LogindSessionsIdle = {
          class = "LogindSessionsIdle";
          enabled = true;
          types = "x11:wayland:mir:unspecified";
          states = "active:online";
        };
        # Keep awake if there are active SSH connections
        ActiveConnection = {
          class = "ActiveConnection";
          enabled = true;
          ports = "22";
        };
        # Keep awake if load is high (something is running)
        Load = {
          class = "Load";
          enabled = true;
          threshold = 5.0;
        };
      };
    };
  };
}
