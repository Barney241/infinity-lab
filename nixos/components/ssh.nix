{ config, pkgs, lib, ... }:
let cfg = config.roles.ssh;
in {
  options.roles.ssh = {
    enable = lib.mkOption {
      default = true;
      example = true;
      type = lib.types.bool;
    };
    startAgent = lib.mkOption {
      default = true;
      example = false;
      type = lib.types.bool;
      description = "Enable SSH agent (disable if using COSMIC/GNOME which has its own)";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.barney.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCHGmpOxOGR9i3CVE1WMT9hudFQ0nlMR32kGazAQGfcOUu7CH49Au6jC8Yj0q11NwmWJba9Osda9xT6VbjQoCDNcfNutCGHtf1WWgl2VKV91tTyeQ4fxjJsN1pAVkqm37l9qyvK8yLRYzyTmrCpf2lFmHCTB5IsQm0K8Us/0uTccbX1jt0d35VjIfJnwmFbEClQZbD9dOfrAPUVvcSHmw9yrsBYFsxdB1kfXoZwqkOs7uoHBSB+MKXX08u5QiFS9c16arTbA5sOk/0wcdC/1nWYj7ymZ7Co0LD90fwMlApSN3bv3AUcJ9Qxu2OoeHbkSleUy1WqxZw+azakIm/vLCZv rsa-key-20220115"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDR0Py0dNvD/DkIpHPXMav6Hmg5xix7dkOG4ztP3BqgSnmq8ebioeDBWIDxRIGBUk69RE1TVJ+iVs60l8M58FtVJiMDbuX0R3JgRJNkCaiwmMTlD3IYin/fAqSk/seQGNj4R7YbT8rNLGhzdRcf1ww76t3w6JlfDfER1lSayS4WjxU4s8m3lCi7r8BdwDp8aOnmaU3vlrwne7/OW/ZQD7oHik4IA9f2zFFVQA/PTWmaQuYtxn1SLPRSRon+Gk6G4lULJ9bFFft9qTscZ8DuyCjQS5uA0F+SSJZRspRRDT+BAIesg2Zx2+HrajA1Y7/2NOsuhWAPpK6e/k8fsB8rqbyD pavel@LAPTOP-30GSN6DN"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKKMAOCLNFjOkE5UQOE7YNYKN3KhTI0r8RTKDWTs0YjZ pavel@aposnachod.cz"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCirT99TobRcN45PmCDyu+gJ20PcrjBQ+mjclmhVpnxYshNhlJT5uCZy7QrqKLfClEWmGg93MdCaS/FfgJG8+hTeis22VXQSaE6wDYp4AH7EduwPTksd/pB0md9zaf5oDNrmn9UdAIWBC1HpYQJlmhIO3cMIx/1ZSJWk1Z0sFOlTlla+Pxn5CQ+YFcalzvV65k22f8IefvK9gKaRh1Hrl8aZYyDDkGGkHOOJyma5rRTulJU2wyWyzW8Zwmn7SNJJ/eRa3Ool/qEznCl3GvF85tJd3ZKhmpORXZdJ/duRsZkG84+UH9A73cbe0GxJZM+4KeYRO5yo09z0b0REebg7A3PCcY5q0qNQCToAJtF5jcj/DayEcjR47QU3GEC9GbCril7iy4s+dqEtmFF5Hj07gwqmTRh+vx92HpDyoWVXdrtcp/oianQIG98o3Mgib89t6TakKOj1pfggVMsrewkmlx3opPZdQsY8zyxEV9n3shgBRuxSntijbKDEb1sZPxhWg0= barney@nixos"
    ];

    programs.mosh.enable = true;
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
      allowSFTP = true;
    };
    programs.ssh.startAgent = cfg.startAgent;
  };
}
