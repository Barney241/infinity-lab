# Common config shared among all machines
{ config, pkgs, hostName, environment, lib, catalog, ... }: {
  system.stateVersion = "24.05";

  imports = [ ./roles ];
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };
  # Garbage collect & optimize /nix/store daily.
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
  nix.optimise.automatic = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = hostName;
  networking.networkmanager.enable = lib.mkDefault true;
  services.resolved.enable = true;

  environment.systemPackages = with pkgs;[
    iwd
    git
    tmux
    tmux-sessionizer
    htop
    jq
    # neovim
    neovim-unwrapped
    tree
    wget
    curl
    lazydocker
    lazygit
    gcc
    unzip
    ripgrep
    fwupd
    pciutils
    nfs-utils
    mdadm
    spaceship-prompt
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  # TODO 
  # services.getty.helpLine =
  #   ">>> Flake node: ${hostName}, environment: ${environment}";

  programs.mosh.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };


  time.timeZone = "Europe/Prague";

  # TODO change
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa aaaab3nzac1yc2eaaaadaqabaaabgqcviittgyggbvlyugbazdviyvym38mkffjl7ynmhwnd5ydnosz12xcom/pnzxt3/rt5igryafes6alkx3epld9xfnbghg2jeqwpgk9cavsjes0wla9mgxvsblpwssjeyp5b8rhd0b8jdia6ciloydhndq2ulvb6c6oqythf2zg1ix+aclwjomq4tazdpspx8mnp1olxfrgufy2xmelfqxju7n+xv+lrhxkyahhuzrgtzq5cxfnwemwsmu5vxyo66oh8v4gogffxrjzqkvddpfpl7ioavkd+kzeq2loqwhzqfof210j5k+pppul0fzuonjlsbw/j+xuxmge0bza0ekxh1aujambzjopeyaaqldmx0ef8ovulipc2csfoqajoiqujushfcqlplowr09eq1zes3whs/i0rxlt0tibdrgsvppew07keral1avqlckmbozuvasacraeon4s4k6xcy0qcvba7pkserxoxchyqpkzprxpbbmagqoxkvzaez8drxlu= barney@barneylaptop"
    "ssh-rsa aaaab3nzac1yc2eaaaadaqabaaabaqdr0py0dnvd/dkiphpxmav6hmg5xix7dkog4ztp3bqgsnmq8ebioedbwidxrigbuk69re1tvj+ivs60l8m58ftvjimdbux0r3jgrjnkcaiwmmtld3iyin/faqsk/seqgnj4r7ybt8rnlghzdrcf1ww76t3w6jlfdfer1lsays4wjxu4s8m3lci7r8bdwdp8aonmau3vlrwne7/ow/zqd7ohik4ia9f2zffvqa/ptwmaquytxn1slprsron+gk6g4lulj9bffft9qtscz8duycjqs5ua0f+ssjzrsprrdt+baiesg2zx2+hraja1y7/2nosuhwappk6e/k8fsb8rqbyd pavel@laptop-30gsn6dn"
  ];

  security.polkit.enable = true;

  users.mutableUsers = false;
  users.users.barney = {
    isNormalUser = true;
    home = "/home/barney";
    description = "barney";
    extraGroups = [ "wheel" ];
    initialPassword = "test";
    openssh.authorizedKeys.keys = [
      "ssh-rsa aaaab3nzac1yc2eaaaadaqabaaabgqcviittgyggbvlyugbazdviyvym38mkffjl7ynmhwnd5ydnosz12xcom/pnzxt3/rt5igryafes6alkx3epld9xfnbghg2jeqwpgk9cavsjes0wla9mgxvsblpwssjeyp5b8rhd0b8jdia6ciloydhndq2ulvb6c6oqythf2zg1ix+aclwjomq4tazdpspx8mnp1olxfrgufy2xmelfqxju7n+xv+lrhxkyahhuzrgtzq5cxfnwemwsmu5vxyo66oh8v4gogffxrjzqkvddpfpl7ioavkd+kzeq2loqwhzqfof210j5k+pppul0fzuonjlsbw/j+xuxmge0bza0ekxh1aujambzjopeyaaqldmx0ef8ovulipc2csfoqajoiqujushfcqlplowr09eq1zes3whs/i0rxlt0tibdrgsvppew07keral1avqlckmbozuvasacraeon4s4k6xcy0qcvba7pkserxoxchyqpkzprxpbbmagqoxkvzaez8drxlu= barney@barneylaptop"
      "ssh-rsa aaaab3nzac1yc2eaaaadaqabaaabaqdr0py0dnvd/dkiphpxmav6hmg5xix7dkog4ztp3bqgsnmq8ebioedbwidxrigbuk69re1tvj+ivs60l8m58ftvjimdbux0r3jgrjnkcaiwmmtld3iyin/faqsk/seqgnj4r7ybt8rnlghzdrcf1ww76t3w6jlfdfer1lsays4wjxu4s8m3lci7r8bdwdp8aonmau3vlrwne7/ow/zqd7ohik4ia9f2zffvqa/ptwmaquytxn1slprsron+gk6g4lulj9bffft9qtscz8duycjqs5ua0f+ssjzrsprrdt+baiesg2zx2+hraja1y7/2nosuhwappk6e/k8fsb8rqbyd pavel@laptop-30gsn6dn"
    ];
  };

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  users.users.root.shell = pkgs.zsh;
  programs.zsh.enable = true;
  systemd.oomd.enable = true;
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  # disk automount
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.fwupd.enable = true;

  # age.secrets = {
  #   influxdb-telegraf.file = ./secrets/influxdb-telegraf.age;
  #   tailscale.file = ./secrets/tailscale.age;
  # };

  # environment.etc."issue.d/ip.issue".text = ''
  #   IPv4: \4
  # '';
  # networking.dhcpcd.runHook = "${pkgs.utillinux}/bin/agetty --reload";

}
