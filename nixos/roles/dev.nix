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
        rustc
        nodejs_20
        cachix
        gnumake
        docker-compose
        jetbrains.jdk
        # jetbrains.jdk-no-jcef
        jetbrains.goland
        # jetbrains.idea-ultimate
        # jetbrains.pycharm-professional
        # jetbrains.phpstorm
        # jetbrains.webstorm
        liquibase
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
