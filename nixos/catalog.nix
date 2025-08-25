# Catalog defines the systems & services on my network.
{ system }: {
  nodes = {
    #lightweight starry traveler
    orion = {
      config = ./hosts/orion.nix;
      hw = ./hw/orion.nix;
      home = ./home/orion.nix;
      system = system.x86_64-linux;
    };

    #brute-force muscle
    serveros = {
      config = ./hosts/serveros.nix;
      hw = ./hw/serveros.nix;
      home = ./home/serveros.nix;
      system = system.x86_64-linux;
    };

    #the silent load-bearer, eternal uptime.
    atlas = {
      config = ./hosts/atlas.nix;
      hw = ./hw/atlas.nix;
      home = ./home/atlas.nix;
      system = system.x86_64-linux;
    };
  };
}
