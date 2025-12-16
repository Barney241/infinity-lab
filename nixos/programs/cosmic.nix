{ config, lib, pkgs, ... }: {
  imports = [
    ./ghostty.nix
    ./audio.nix
    ./desktop.nix
    ./firefox.nix
    ./superfile.nix
  ];

  home.file.".config/wallpapers".source = (pkgs.fetchFromGitHub {
    owner = "Barney241";
    repo = "desktop-wallpapers";
    rev = "a2075354eef856bbf1f507de44504d1a5cbb01c4";
    hash = "sha256-avBC0jiXfInhH9avVcyKtNQudXeP7THJkw9QpnBONbA=";
  });

  home.packages = [
    pkgs.dbus
    pkgs.wl-clipboard
    pkgs.kdePackages.kdeconnect-kde
    pkgs.dconf
    pkgs.brightnessctl
    pkgs.playerctl
  ];

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "cosmic";
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
    };
    theme = {
      name = "Catppuccin-Macchiato-Compact-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = "macchiato";
      };
    };
  };

  # COSMIC keybindings configuration (i3/sway-like)
  # See: https://wiki.nixos.org/wiki/COSMIC
  # Keybindings are stored in RON format at ~/.config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom
  home.file.".config/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom".text = ''
    (
        // Terminal - Super+Return
        ([(Super,), (Return,)], Spawn("ghostty")),

        // File manager - Super+Shift+Return
        ([(Super, Shift), (Return,)], Spawn("cosmic-files")),

        // Close window - Super+q
        ([(Super,), (Q,)], Close),

        // Application launcher - Super+d
        ([(Super,), (D,)], Launcher),

        // Focus navigation (vim-style) - Super+h/j/k/l
        ([(Super,), (H,)], Focus(Left)),
        ([(Super,), (J,)], Focus(Down)),
        ([(Super,), (K,)], Focus(Up)),
        ([(Super,), (L,)], Focus(Right)),

        // Move windows - Super+Shift+h/j/k/l
        ([(Super, Shift), (H,)], Move(Left)),
        ([(Super, Shift), (J,)], Move(Down)),
        ([(Super, Shift), (K,)], Move(Up)),
        ([(Super, Shift), (L,)], Move(Right)),

        // Workspace switching - Super+1-9
        ([(Super,), (Key1,)], Workspace(1)),
        ([(Super,), (Key2,)], Workspace(2)),
        ([(Super,), (Key3,)], Workspace(3)),
        ([(Super,), (Key4,)], Workspace(4)),
        ([(Super,), (Key5,)], Workspace(5)),
        ([(Super,), (Key6,)], Workspace(6)),
        ([(Super,), (Key7,)], Workspace(7)),
        ([(Super,), (Key8,)], Workspace(8)),
        ([(Super,), (Key9,)], Workspace(9)),

        // Move window to workspace - Super+Shift+1-9
        ([(Super, Shift), (Key1,)], MoveToWorkspace(1)),
        ([(Super, Shift), (Key2,)], MoveToWorkspace(2)),
        ([(Super, Shift), (Key3,)], MoveToWorkspace(3)),
        ([(Super, Shift), (Key4,)], MoveToWorkspace(4)),
        ([(Super, Shift), (Key5,)], MoveToWorkspace(5)),
        ([(Super, Shift), (Key6,)], MoveToWorkspace(6)),
        ([(Super, Shift), (Key7,)], MoveToWorkspace(7)),
        ([(Super, Shift), (Key8,)], MoveToWorkspace(8)),
        ([(Super, Shift), (Key9,)], MoveToWorkspace(9)),

        // Toggle floating - Super+Shift+Space
        ([(Super, Shift), (Space,)], ToggleFloating),

        // Fullscreen - F11 and Super+Shift+f
        ([(None,), (F11,)], Maximize),
        ([(Super, Shift), (F,)], Maximize),

        // Split orientation
        ([(Super,), (B,)], Orientation(Horizontal)),
        ([(Super,), (V,)], Orientation(Vertical)),

        // Cycle through recent workspaces - Super+Tab
        ([(Super,), (Tab,)], LastWorkspace),

        // Screenshot region
        ([(None,), (Print,)], Screenshot(Region)),
        ([(Ctrl,), (Print,)], Screenshot(Screen)),
    )
  '';

  # COSMIC tiling settings - enable auto-tiling by default
  home.file.".config/cosmic/com.system76.CosmicComp/v1/autotile".text = ''
    true
  '';

  # COSMIC tiling gaps (similar to i3/sway)
  home.file.".config/cosmic/com.system76.CosmicComp/v1/active_hint".text = ''
    true
  '';
}
