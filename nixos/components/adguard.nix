{ config, lib, ... }:
let cfg = config.roles.adguard;
in {
  options.roles.adguard = {
    enable = lib.mkEnableOption "AdGuard Home ad blocker";
    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port for the AdGuard Home web interface.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Disable resolved's stub listener so AdGuard can bind port 53
    services.resolved.extraConfig = ''
      DNSStubListener=no
    '';

    # Point the system resolver at AdGuard
    networking.nameservers = [ "127.0.0.1" "1.1.1.1" ];

    services.adguardhome = {
      enable = true;
      mutableSettings = true;
      port = cfg.port;
      settings = {
        dns = {
          bind_hosts = [ "0.0.0.0" ];
          port = 53;
        };
      };
    };
  };
}
