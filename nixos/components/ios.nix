{ config, pkgs, lib, ... }:
let cfg = config.roles.ios;
in {
  options.roles.ios = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    # https://nixos.wiki/wiki/IOS
    services.usbmuxd.enable = true;

    environment.systemPackages = with pkgs; [
      libimobiledevice
      ifuse # optional, to mount using 'ifuse'
    ];

    # Mounting the device via iFuse is possible with the following commands
    # $ mkdir /tmp/iphone
    # $ ifuse /tmp/iphone

    # Tethering on iOS is possible via Wifi hotspot, Bluetooth or USB. In order to enable USB tethering, first enable tethering in the iOS networking settings. After that run following command
    # $ idevicepair pair

  };
}

