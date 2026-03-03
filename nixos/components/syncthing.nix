{ config, lib, ... }:
let
  cfg = config.roles.syncthing;

  # Device IDs — populate these after first deployment by visiting
  # http://localhost:8384 on each host and copying the device ID.
  # Then set overrideDevices = true for fully declarative management.
  deviceIds = {
    atlas = "XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX";
    orion = "XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX";
    serveros = "42EJJCY-QEAZMHX-GWCWBAP-X4JCWUO-H4TTZ2C-R2P3MAI-HVXDHIB-5ZTIZQT";
  };

  thisHost = config.networking.hostName;
  otherDevices = lib.filterAttrs (name: _: name != thisHost) deviceIds;
  knownDevices = lib.mapAttrs (name: id: { inherit id; }) otherDevices;

in {
  options.roles.syncthing = {
    enable = lib.mkEnableOption "Syncthing file sync";

    # Set to true once all device IDs are filled in above to prevent
    # manual GUI changes from persisting across rebuilds.
    override = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Override devices and folders declaratively (disables GUI management)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      # Runs as dedicated 'syncthing' system user — contained to /sync only.
      dataDir = "/var/lib/syncthing";
      overrideDevices = cfg.override;
      overrideFolders = cfg.override;
      settings = {
        devices = knownDevices;
        folders = {
          "sync" = {
            path = "/sync";
            devices = lib.attrNames otherDevices;
          };
        };
      };
    };

    # Create /sync owned by syncthing, group-writable so barney can use it.
    systemd.tmpfiles.rules = [
      "d /sync 0770 syncthing syncthing -"
    ];

    # Add barney to the syncthing group so he can read/write /sync.
    users.users.barney.extraGroups = [ "syncthing" ];

    networking.firewall = {
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };
  };
}
