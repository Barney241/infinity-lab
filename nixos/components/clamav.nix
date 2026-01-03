{ config, lib, pkgs, ... }:
let cfg = config.roles.clamav;
in {
  options.roles.clamav = {
    enable = lib.mkEnableOption "ClamAV on-demand scanning";
    dailyScan = lib.mkEnableOption "Daily scheduled scan of /home";
  };

  config = lib.mkIf cfg.enable {
    # On-demand scanning tool
    environment.systemPackages = [ pkgs.clamav ];

    # Signature updater (freshclam)
    services.clamav.updater.enable = true;

    # Optional daily scan timer
    systemd.services.clamav-scan = lib.mkIf cfg.dailyScan {
      description = "ClamAV daily scan";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.clamav}/bin/clamscan -r --infected --log=/var/log/clamav/scan.log /home";
      };
    };

    systemd.timers.clamav-scan = lib.mkIf cfg.dailyScan {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };
}
