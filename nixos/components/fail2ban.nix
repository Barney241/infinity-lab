{ config, lib, ... }:
let cfg = config.roles.fail2ban;
in {
  options.roles.fail2ban = {
    enable = lib.mkEnableOption "Fail2Ban SSH brute-force protection";
  };

  config = lib.mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      maxretry = 5;
      bantime = "10m";
      jails.sshd = {
        settings = {
          enabled = true;
          filter = "sshd";
          maxretry = 5;
        };
      };
    };
  };
}
