{ config, pkgs, lib, ... }:
let cfg = config.gpus.nvidia;
in {
  options.gpus.nvidia = { enable = lib.mkEnableOption "Enable nvidia gpu"; };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.cudaSupport = true;
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    environment.systemPackages = [
      pkgs.nvtopPackages.full
      pkgs.cudaPackages.cudatoolkit
      pkgs.cudaPackages.cudnn
      pkgs.cudaPackages.cutensor
      # pkgs.linuxPackages.nvidia_x11
    ];
    boot.initrd.kernelModules =
      [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    boot.blacklistedKernelModules = [ "nouveau" ];
    # boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

    # Load nvidia driver for Xorg and Wayland
    # services.xserver.videoDrivers = [ "nvidia" ]; # conflict with nvidia-x11

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;
      nvidiaPersistenced = true;
      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = true;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;
      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of 
      # supported GPUs is at: 
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
      # Only available from driver 515.43.04+
      # Do not disable this unless your GPU is unsupported or if you have a good reason to.
      open = false;
      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;
      # Optionally, you may need to select the appropriate driver version for your specific GPU.

      # package = config.boot.kernelPackages.nvidiaPackages.stable;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      # package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
    };
  };
}
