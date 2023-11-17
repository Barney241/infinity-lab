{ config, pkgs, ... }:
{
  imports = [
    ./system.nix
    ./networking.nix
    ./dns.nix
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "bira";
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    netclient
  ];
  services.netclient = {
    enable = true;
  };

  users.extraUsers.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvIiTTgyGGBVlYUgbAzdViyVYm38mKFfjL7YnmHwND5yDnoSZ12xCoM/pnZxT3/rT5iGRYaFeS6aLKX3ePLD9xfnbGHG2JeQWPGK9cavSJEs0WLa9MGXvsBlPWSSJeYp5B8rhd0B8jDIA6CILoyDhnDQ2ulVB6c6OQYThf2zG1IX+AclWjomQ4tAzDpsPX8MnP1OLXfrgUfY2xmeLFQxJU7n+xv+LRHXKyAhHUZrGTzQ5CxFnwEmWSMU5VXyO66Oh8v4GOGfFXrJzQKVddpfpl7iOAVkD+kZeq2loqwhZQFOF210j5k+pppuL0FZUONJlsbw/j+xuxMgE0BZA0ekXH1aUjAmbZjoPeyAAqldMx0eF8OVUlIpC2cSfOQaJOiQUjushfcqLPlOwr09Eq1ZES3Whs/I0RXLt0tIBDRGSVpPew07keRAL1AVqlCKMboZUVASacRAEOn4s4K6XCY0QcVBA7PKSErXOXcHyQpkZPRXpBBmagQoXKVZaEz8DrXLU= barney@BarneyLaptop",
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDR0Py0dNvD/DkIpHPXMav6Hmg5xix7dkOG4ztP3BqgSnmq8ebioeDBWIDxRIGBUk69RE1TVJ+iVs60l8M58FtVJiMDbuX0R3JgRJNkCaiwmMTlD3IYin/fAqSk/seQGNj4R7YbT8rNLGhzdRcf1ww76t3w6JlfDfER1lSayS4WjxU4s8m3lCi7r8BdwDp8aOnmaU3vlrwne7/OW/ZQD7oHik4IA9f2zFFVQA/PTWmaQuYtxn1SLPRSRon+Gk6G4lULJ9bFFft9qTscZ8DuyCjQS5uA0F+SSJZRspRRDT+BAIesg2Zx2+HrajA1Y7/2NOsuhWAPpK6e/k8fsB8rqbyD pavel@LAPTOP-30GSN6DN"
  ];
}
