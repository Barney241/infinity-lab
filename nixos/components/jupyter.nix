{ config, pkgs, lib, ... }:
# Jupyter password is stored in agenix secret
# Generate hash: python3 -c "from notebook.auth import passwd; print(passwd('yourpassword'))"
# Create secret: cd nixos/secrets && agenix -e jupyter-password.age
let
  cfg = config.roles.jupyter;
  pythonJupyter = pkgs.python311.withPackages
    (ps: with ps; [ jupyterlab jupyterlab-lsp python-lsp-server ]);
  pythonKernel = pkgs.python311.withPackages (pythonPackages:
    with pythonPackages; [
      pytorch-bin
      jupyter
      jupyterlab
      jupyterlab-lsp
      ipykernel
      ipython
      pandas
      scikit-learn
    ]);
  cuda = pkgs.cudaPackages.cudatoolkit;
  cudnn = pkgs.cudaPackages.cudnn;
in {
  options.roles.jupyter = { enable = lib.mkEnableOption "Enable jupyter lab"; };

  config = lib.mkIf cfg.enable {
    nixpkgs.config = {
      cudaSupport = true;
      cudaVersion = "12";
    };

    users.groups.jupyter.members = [ "barney" ];
    users.groups.jupyter = { };

    environment.systemPackages = with pkgs; [ pythonKernel ];

    # Patch jupyter config with password from agenix secret before service starts
    systemd.services.jupyter.serviceConfig.ExecStartPre = let
      passwordFile = config.age.secrets.jupyter-password.path;
      configDir = "/var/lib/jupyter";
    in [
      "${pkgs.coreutils}/bin/mkdir -p ${configDir}"
      ''${pkgs.bash}/bin/bash -c "echo \"c.ServerApp.password = '$(cat ${passwordFile})'\" > ${configDir}/jupyter_server_config.py"''
    ];

    services.jupyter = {
      enable = true;
      ip = "0.0.0.0";
      port = 8888;
      command = "jupyter-lab";
      user = "barney";
      group = "jupyter";
      password = ""; # Handled by ExecStartPre above
      notebookDir = "~/Projects/jupyter";
      package = pythonJupyter;
      kernels = {
        python3 = {
          displayName = "Python 3 for machine learning";
          env = {
            CUDA_PATH = "${cuda}";
            CUDATKDIR = "${cuda}";
            # might set too many things, can be probably simplified
            LD_LIBRARY_PATH =
              "/usr/lib/x86_64-linux-gnu:${pkgs.mkl}/lib:${pkgs.libsndfile.out}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:${pkgs.linuxPackages.nvidia_x11}/lib:${cuda}/lib:${cuda.lib}/lib:${cudnn}/lib:$LD_LIBRARY_PATH";
            EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
            EXTRA_CCFLAGS = "-I/usr/include";
          };
          argv = [
            "${pythonKernel.interpreter}"
            "-m"
            "ipykernel_launcher"
            "-f"
            "{connection_file}"
          ];
          language = "python";
        };
      };
    };
  };
}
