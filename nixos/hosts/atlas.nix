{ pkgs, ... }: {
  imports = [ ../common.nix ];
  networking = {
    hostName = "atlas";
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

  environment.systemPackages = [ pkgs.ghostty ];

  roles = {
    docker = { enable = true; };
    dev = {
      cli = true;
      gui = false;
    };
    lsp = {
      go = true;
      rust = true;
    };
    tailscale = { enable = true; };
    ssh = { enable = true; };
  };
}
