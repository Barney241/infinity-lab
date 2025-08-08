{ lib, config, pkgs, modulesPath, ... }: {
  boot.kernel.sysctl = {
    # Note that inotify watches consume 1kB on 64-bit machines.
    "fs.inotify.max_user_watches" = 1024000; # default:  8192
    "fs.inotify.max_user_instances" = 2048; # default:   128
    "fs.inotify.max_queued_events" = 32768; # default: 16384
    "fs.file-max" = 2097152;

    "net.core.netdev_max_backlog" = 16384;
    "net.core.somaxconn" = 8192;
    "net.ipv4.tcp_slow_start_after_idle" = 0;
  };
  boot.kernelParams = [ "loglevel=0" "nmi_watchdog=0" "nowatchdog" ];

  systemd.oomd.enable = true;
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "10s";
    DefaultLimitNOFILE = "4096:1048576";
  };

  hardware.enableAllFirmware = lib.mkDefault true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.ledger.enable = lib.mkDefault true;

  imports = [ ./gpu/default.nix ];
}
