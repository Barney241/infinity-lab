{
  description = "Input into the infinity lab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    stable.url = "github:NixOS/nixpkgs/25.05";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    # flake-utils.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    nix-gaming.url = "github:fufexan/nix-gaming";

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # KDE
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, master, stable, nur, flake-utils, home-manager, ...
    }@attrs:
    let
      inherit (nixpkgs.lib) mapAttrs nixosSystem;

      inherit (flake-utils.lib) system;

      # catalog.nodes defines the systems available in this flake.
      catalog = import ./nixos/catalog.nix { inherit system; };
    in {
      # Convert nodes into a set of nixos configs.
      nixosConfigurations = let
        # Bare metal systems.
        metalSystems = mapAttrs (host: node:
          let
            stablePkgs = import stable {
              inherit (node) system;
              config = {
                allowUnfree = true;
                allowBroken = true;
                permittedInsecurePackages = [ "electron-25.9.0" ];
              };
            };
            masterPkgs = import master {
              inherit (node) system;
              config = {
                allowUnfree = true;
                allowBroken = true;
                permittedInsecurePackages = [ "electron-25.9.0" ];
              };
            };
          in nixosSystem {
            inherit (node) system;
            specialArgs = attrs // {
              inherit catalog;
              inherit attrs;
              hostName = host;
              stable = stablePkgs;
              master = masterPkgs;
            };
            modules = [
              nur.modules.nixos.default
              attrs.chaotic.nixosModules.default
              attrs.vscode-server.nixosModules.default
              node.config
              node.hw
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.barney = import node.home;
                home-manager.backupFileExtension = "backup1";
              }
            ];
          }) catalog.nodes;
      in metalSystems;
    };
}
