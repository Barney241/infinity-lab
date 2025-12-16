{ config, pkgs, ... }: {
  imports = [ ../common.nix ];
  networking.hostName = "orion";

  sway.enable = true;

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
    gaming = { enable = true; };
    pipewire = { enable = true; };
    ssh = {
      enable = true;
      startAgent = false;
    }; # COSMIC has its own
    ios = { enable = true; };
    pam = { fingerprint.enable = false; };
    llm-tools = { enable = true; };
    netdata = { enable = true; };
    agenix = { enable = true; };
    auto-cpufreq = {
      enable = true;
      profile = "laptop";
    };
  };
}
