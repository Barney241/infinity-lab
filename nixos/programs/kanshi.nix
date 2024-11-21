{
  services.kanshi = {
    enable = true;
    systemdTarget = "sway-session.target";

    settings = [
    {
        profile.outputs = [
        {
            criteria = "eDP-1";
            scale = 1.3;
        }
        ];
    }
    {
        profile.outputs = [
        {
            criteria = "eDP-1";
            scale = 1.3;
            status = "enable";
            mode = "2880x1800";
            position = "8240,0";
          }
          {
            criteria = "DP-7";
            scale = 1.3;
            status = "enable";
            mode = "3840x2160@30Hz";
            position = "5279,0";
          }
          {
            criteria = "DP-9";
            scale = 1.3;
            status = "enable";
            mode = "3840x2160@30Hz";
            position = "3614,0";
            transform = "90";
          }
        ];
    }
    {
        profile.outputs = [
        {
            criteria = "eDP-1";
            scale = 1.3;
            status = "enable";
            mode = "2880x1800";
            position = "8240,0";
          }
          {
            criteria = "DP-8";
            scale = 1.3;
            status = "enable";
            mode = "3840x2160@30Hz";
            position = "5279,0";
          }
          {
            criteria = "DP-11";
            scale = 1.3;
            status = "enable";
            mode = "3840x2160@30Hz";
            position = "3614,0";
            transform = "90";
          }
        ];
    }
    ];

  };
}
