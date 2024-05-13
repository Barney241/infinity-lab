# Catalog defines the systems & services on my network.
{ system }: {
  nodes = {
    orion = {
      config = ./hosts/orion.nix;
      hw = ./hw/orion.nix;
      home = ./home/orion.nix;
      system = system.x86_64-linux;
    };

    serveros = {
      config = ./hosts/serveros.nix;
      hw = ./hw/serveros.nix;
      home = ./home/serveros.nix;
      system = system.x86_64-linux;
    };
  };
}
