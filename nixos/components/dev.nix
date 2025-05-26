{ config, pkgs, lib, ... }:
let cfg = config.roles.dev;
in {
  options.roles.dev = { enable = lib.mkEnableOption "Enable dev tools"; };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bash
      doctl
      postgresql_16

      kubectl
      kdash # kubernetes dashboard

      nil
      rustup
      # go
      go_1_23
      natscli

      #rust
      rustc
      cargo
      pkg-config
      openssl
      rustfmt
      rustup

      #lsp
      buf

      nodejs_20
      cachix
      gnumake
      docker-compose
      # jetbrains.jdk
      # jetbrains.goland
      jetbrains.idea-ultimate
      code-cursor
      # jetbrains.pycharm-professional
      # jetbrains.phpstorm
      # jetbrains.webstorm
      # poetry
    ];

    services.vscode-server.enable = true;

    programs.direnv = {
      enable = true;
      loadInNixShell = true;
      nix-direnv = { enable = true; };
    };
  };
}
