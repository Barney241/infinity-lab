{ config, pkgs, lib, stable, ... }:
let cfg = config.roles.dev;
in {
  options.roles.dev = {
    cli = lib.mkEnableOption "Enable dev tools";
    gui = lib.mkEnableOption "Enable dev gui tools";
  };

  config = lib.mkMerge [
    ({
      services.vscode-server.enable = true;

      programs.direnv = {
        enable = true;
        loadInNixShell = true;
        nix-direnv = { enable = true; };
      };
    })

    (lib.mkIf cfg.cli {
      environment.systemPackages = with pkgs; [
        bash
        doctl
        postgresql_16

        kubectl
        stable.kdash # kubernetes dashboard (stable: GCC 15 compat issue)

        nil
        rustup
        # go
        go
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

        #python
        uv

        nodejs_20
        cachix
        gnumake
        docker-compose
      ];
    })

    (lib.mkIf cfg.gui {
      environment.systemPackages = with pkgs; [
        dbeaver-bin
        jetbrains.idea
        # jetbrains.jdk
        # jetbrains.goland
        # code-cursor
        # jetbrains.pycharm-professional
        # jetbrains.phpstorm
        # jetbrains.webstorm
      ];
    })
  ];
}

