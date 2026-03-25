{ config, lib, pkgs, zen-browser ? null, ... }:
let
  cfg = config.browser;

  browsers = {
    zen = {
      desktopFile = "zen.desktop";
      command = "zen";
      package = zen-browser.default;
    };
    firefox = {
      desktopFile = "firefox.desktop";
      command = "firefox";
      package = null; # managed by programs.firefox
    };
    chromium = {
      desktopFile = "chromium-browser.desktop";
      command = "chromium";
      package = pkgs.chromium;
    };
  };

  selected = browsers.${cfg.default};
in {
  options.browser = {
    default = lib.mkOption {
      type = lib.types.enum (builtins.attrNames browsers);
      default = "zen";
      description = "The default browser for opening links";
    };
    extra = lib.mkOption {
      type = lib.types.listOf (lib.types.enum (builtins.attrNames browsers));
      default = [];
      description = "Additional browsers to install alongside the default";
    };
  };

  config = {
    xdg.mimeApps.defaultApplications = {
      "text/html" = selected.desktopFile;
      "x-scheme-handler/http" = selected.desktopFile;
      "x-scheme-handler/https" = selected.desktopFile;
      "x-scheme-handler/about" = selected.desktopFile;
      "x-scheme-handler/unknown" = selected.desktopFile;
    };

    # Set $BROWSER so CLI tools (xdg-open, etc.) can find it
    home.sessionVariables = {
      BROWSER = selected.command;
    } // lib.optionalAttrs (cfg.default == "firefox") {
      MOZ_ENABLE_WAYLAND = 1;
    };

    # Xfce has its own preferred-applications system that ignores XDG mimeapps.
    # These files are harmless on non-Xfce desktops (just unused).
    home.file.".local/share/xfce4/helpers/custom-WebBrowser.desktop".text = lib.generators.toINI {} {
      "Desktop Entry" = {
        NoDisplay = true;
        Version = "1.0";
        Encoding = "UTF-8";
        Type = "X-XFCE-Helper";
        "X-XFCE-Category" = "WebBrowser";
        "X-XFCE-CommandsWithParameter" = "${selected.command} \"%s\"";
        Icon = selected.command;
        Name = selected.command;
        "X-XFCE-Commands" = selected.command;
      };
    };

    xdg.configFile."xfce4/helpers.rc".text = "WebBrowser=custom-WebBrowser\n";

    programs.firefox = lib.mkIf (cfg.default == "firefox") {
      enable = true;
      package = pkgs.firefox;
    };

    home.packages =
      lib.optional (selected.package != null) selected.package
      ++ lib.concatMap (name: let b = browsers.${name}; in lib.optional (b.package != null) b.package) cfg.extra;
  };
}
