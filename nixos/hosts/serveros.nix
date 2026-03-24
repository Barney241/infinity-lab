{ ... }:
{
  imports = [ ../common.nix ];
  networking = {
    hostName = "serveros";
    firewall = {
      enable = true;
      allowPing = true;
      allowedUDPPortRanges = [
        {
          from = 0;
          to = 65535;
        }
      ];
      allowedTCPPortRanges = [
        {
          from = 0;
          to = 65535;
        }
      ];
    };
  };

  i3.enable = true;

  roles = {
    desktop = {
      enable = true;
    };
    docker = {
      enable = true;
    };
    dev = {
      cli = true;
      gui = true;
    };
    lsp = {
      go = true;
      rust = true;
    };
    tailscale = {
      enable = true;
    };
    jupyter = {
      enable = false; # dependecy failure
    };
    gaming = {
      enable = true;
    };
    pipewire = {
      enable = true;
    };
    ssh = {
      enable = true;
      startAgent = false; # XFCE provides gnome-keyring/gcr-ssh-agent
    };
    ai = {
      enable = true;
    };
    pam = {
      fingerprint.enable = false;
    };
    llm-tools = {
      enable = true;
    };
    agenix = {
      enable = true;
    };
    syncthing = {
      enable = true;
    };
    auto-cpufreq = {
      enable = true;
      profile = "desktop-performance";
    };
    autosuspend = {
      enable = true;
    };
    fail2ban = {
      enable = true;
    };
    clamav = {
      enable = true;
      dailyScan = true;
    };
  };

  boot.kernelParams = [ "mem_sleep_default=deep" ];
}
