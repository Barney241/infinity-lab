{ config, lib, ... }:
let cfg = config.roles.auto-cpufreq;
in {
  options.roles.auto-cpufreq = {
    enable = lib.mkEnableOption "auto-cpufreq power management";

    profile = lib.mkOption {
      type = lib.types.enum [ "laptop" "desktop-performance" "desktop-powersave" ];
      default = "desktop-performance";
      description = "Power profile preset";
    };
  };

  config = lib.mkIf cfg.enable {
    services.auto-cpufreq.enable = true;
    services.auto-cpufreq.settings =
      if cfg.profile == "laptop" then {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      }
      else if cfg.profile == "desktop-performance" then {
        charger = {
          governor = "performance";
          energy_performance_preference = "balance_power";
          turbo = "auto";
        };
      }
      else {
        charger = {
          governor = "powersave";
          energy_performance_preference = "balance_power";
          turbo = "auto";
        };
      };
  };
}
