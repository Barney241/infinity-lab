{
  description = "Input into the infinity lab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";

    vscode-server.url = "github:nix-community/nixos-vscode-server";

    zig.url = "github:mitchellh/zig-overlay";
    zig.inputs.nixpkgs.follows = "nixpkgs";

    zls.url = "github:zigtools/zls";
    zls.inputs.nixpkgs.follows = "nixpkgs";
    zls.inputs.zig-overlay.follows = "zig";
  };

  outputs = { self, nixpkgs, nixpkgs-wayland, agenix, flake-utils, home-manager, hyprland, vscode-server, nixos-generators, zig, zls, ... }@attrs:
    let
      inherit (nixpkgs.lib)
        mapAttrs mapAttrs' nixosSystem;

      inherit (flake-utils.lib) eachSystemMap system;

      # catalog.nodes defines the systems available in this flake.
      catalog = import ./nixos/catalog.nix { inherit system; };
    in
    rec {
      # Convert nodes into a set of nixos configs.
      nixosConfigurations =
        let
          # Bare metal systems.
          metalSystems = mapAttrs
            (host: node:
              nixosSystem {
                inherit (node) system;
                specialArgs = attrs // {
                  inherit catalog;
                  hostName = host;
                  zig = zig.packages.${node.system};
                  zls = zls.packages.${node.system};
                };
                modules = [
                  node.config
                  node.hw
                  home-manager.nixosModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.barney = import node.home;
                    home-manager.backupFileExtension = "backup";
                  }
                  agenix.nixosModules.default
                  {
                    environment.systemPackages = [ agenix.packages.${node.system}.default ];
                  }

                  vscode-server.nixosModules.default
                  ({ config, pkgs, ... }: {
                    services.vscode-server.enable = true;
                  })
                ];
              })
            catalog.nodes;
        in
        metalSystems;
    };
}
