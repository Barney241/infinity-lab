{ config, pkgs, lib, ... }:
let
  cfg = config.roles.dev;
in
{
  options.roles.dev = {
    enable = lib.mkEnableOption "Enable dev tools";
  };

  config = lib.mkIf cfg.enable
    {
      environment.systemPackages = with pkgs;[
        bash
        doctl
        postgresql_16
        kubectl
        nil
        rustup
        # go
        go_1_22
        natscli

        #rust
        rustc
        cargo
        pkg-config
        openssl
        rustfmt
        rustup
        
        #lsp
        rust-analyzer
        buf-language-server

        nodejs_20
        cachix
        gnumake
        docker-compose
        jetbrains.jdk
        jetbrains.goland
        jetbrains.idea-ultimate
        # jetbrains.pycharm-professional
        # jetbrains.phpstorm
        # jetbrains.webstorm
        liquibase
        # poetry
      ];


      programs.direnv = {
        enable = true;
        loadInNixShell = true;
        nix-direnv = {
          enable = true;
        };
      };
    };
}
