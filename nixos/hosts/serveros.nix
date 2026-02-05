{ ... }: {
  imports = [ ../common.nix ];
  networking = {
    hostName = "serveros";
    firewall = {
      enable = true;
      allowPing = true;
      allowedUDPPortRanges = [{
        from = 0;
        to = 65535;
      }];
      allowedTCPPortRanges = [{
        from = 0;
        to = 65535;
      }];
    };
  };

  i3.enable = true;

  roles = {
    desktop = { enable = true; };
    docker = { enable = true; };
    dev = {
      cli = true;
      gui = true;
    };
    lsp = {
      go = true;
      rust = true;
    };
    tailscale = { enable = true; };
    jupyter = {
      enable = false; # dependecy failure
    };
    gaming = { enable = true; };
    pipewire = { enable = true; };
    ssh = { enable = true; };
    ai = { enable = true; };
    pam = { fingerprint.enable = false; };
    llm-tools = { enable = true; };
    netdata = { enable = true; };
    agenix = { enable = true; };
    auto-cpufreq = {
      enable = true;
      profile = "desktop-performance";
    };
    fail2ban = { enable = true; };
    clamav = {
      enable = true;
      dailyScan = true;
    };
  };
}
