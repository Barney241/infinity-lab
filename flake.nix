{
  description = "Input into the snowy lab";

  inputs = {
    nixpkgs.url = "github:wexder/nixpkgs/netclient";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, agenix, flake-utils, ... }@attrs:
    let
      inherit (nixpkgs.lib)
        mapAttrs mapAttrs' mapAttrsToList mkMerge nixosSystem;

      inherit (flake-utils.lib) eachSystemMap system;

      # catalog.nodes defines the systems available in this flake.
      catalog = import ./catalog.nix { inherit system; };
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
                  environment = "prod";
                };
                modules = [ node.config node.hw agenix.nixosModule ];
              })
            catalog.nodes;
        in
        metalSystems;

      # Generate an SD card image for each host.
      images = mapAttrs
        (host: node: nixosConfigurations.${host}.config.system.build.sdImage)
        catalog.nodes;

      # Generate VM build packages to quick test each host.  Note that these
      # will will be x86-64 VMs, and will have a new host key, thus will be
      # unable to decrypt agenix secrets.
      packages =
        let
          # Converts node entry into a virtual machine package.
          vmPackage = sys: host: node: {
            name = host;
            value = (nixosSystem {
              system = sys;
              specialArgs = attrs // {
                inherit catalog;
                hostName = host;
                environment = "test";
              };
              modules = [ node.config ./hw/qemu.nix agenix.nixosModule ];
            }).config.system.build.vm;
          };
        in
        eachSystemMap [ system.x86_64-linux ]
          (sys: mapAttrs' (vmPackage sys) catalog.nodes);
    };
}
