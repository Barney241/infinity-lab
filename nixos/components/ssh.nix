{ config, pkgs, lib, ... }:
let
  cfg = config.roles.ssh;
in
{
  options.roles.ssh = {
    enable = lib.mkOption {
      default = true;
      example = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable
    {
        users.users.barney.openssh.authorizedKeys.keys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvIiTTgyGGBVlYUgbAzdViyVYm38mKFfjL7YnmHwND5yDnoSZ12xCoM/pnZxT3/rT5iGRYaFeS6aLKX3ePLD9xfnbGHG2JeQWPGK9cavSJEs0WLa9MGXvsBlPWSSJeYp5B8rhd0B8jDIA6CILoyDhnDQ2ulVB6c6OQYThf2zG1IX+AclWjomQ4tAzDpsPX8MnP1OLXfrgUfY2xmeLFQxJU7n+xv+LRHXKyAhHUZrGTzQ5CxFnwEmWSMU5VXyO66Oh8v4GOGfFXrJzQKVddpfpl7iOAVkD+kZeq2loqwhZQFOF210j5k+pppuL0FZUONJlsbw/j+xuxMgE0BZA0ekXH1aUjAmbZjoPeyAAqldMx0eF8OVUlIpC2cSfOQaJOiQUjushfcqLPlOwr09Eq1ZES3Whs/I0RXLt0tIBDRGSVpPew07keRAL1AVqlCKMboZUVASacRAEOn4s4K6XCY0QcVBA7PKSErXOXcHyQpkZPRXpBBmagQoXKVZaEz8DrXLU= barney@BarneyLaptop"
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCHGmpOxOGR9i3CVE1WMT9hudFQ0nlMR32kGazAQGfcOUu7CH49Au6jC8Yj0q11NwmWJba9Osda9xT6VbjQoCDNcfNutCGHtf1WWgl2VKV91tTyeQ4fxjJsN1pAVkqm37l9qyvK8yLRYzyTmrCpf2lFmHCTB5IsQm0K8Us/0uTccbX1jt0d35VjIfJnwmFbEClQZbD9dOfrAPUVvcSHmw9yrsBYFsxdB1kfXoZwqkOs7uoHBSB+MKXX08u5QiFS9c16arTbA5sOk/0wcdC/1nWYj7ymZ7Co0LD90fwMlApSN3bv3AUcJ9Qxu2OoeHbkSleUy1WqxZw+azakIm/vLCZv rsa-key-20220115"
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDR0Py0dNvD/DkIpHPXMav6Hmg5xix7dkOG4ztP3BqgSnmq8ebioeDBWIDxRIGBUk69RE1TVJ+iVs60l8M58FtVJiMDbuX0R3JgRJNkCaiwmMTlD3IYin/fAqSk/seQGNj4R7YbT8rNLGhzdRcf1ww76t3w6JlfDfER1lSayS4WjxU4s8m3lCi7r8BdwDp8aOnmaU3vlrwne7/OW/ZQD7oHik4IA9f2zFFVQA/PTWmaQuYtxn1SLPRSRon+Gk6G4lULJ9bFFft9qTscZ8DuyCjQS5uA0F+SSJZRspRRDT+BAIesg2Zx2+HrajA1Y7/2NOsuhWAPpK6e/k8fsB8rqbyD pavel@LAPTOP-30GSN6DN"
        ];

        programs.mosh.enable = true;
        services.openssh = {
            enable = true;
            settings = {
              PasswordAuthentication = false;
              KbdInteractiveAuthentication = false;
            };
            allowSFTP = true;
        };
        programs.ssh.startAgent = true;
   };
}
