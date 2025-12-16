{ config, lib, pkgs, attrs, ... }:
let cfg = config.roles.agenix;
in {
  options.roles.agenix = {
    enable = lib.mkEnableOption "agenix secrets management";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      environment.systemPackages =
        [ pkgs.age attrs.agenix.packages.${pkgs.system}.default ];

      # User password hash
      age.secrets.barney-password = { file = ../secrets/barney-password.age; };
    }

    # Jupyter password - only when jupyter is enabled
    (lib.mkIf config.roles.jupyter.enable {
      age.secrets.jupyter-password = {
        file = ../secrets/jupyter-password.age;
        owner = "barney";
        group = "jupyter";
        mode = "0440";
      };
    })
  ]);
}
