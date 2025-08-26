{ pkgs, ... }:

{
  imports = [
    ./common.nix
    ../programs/zsh.nix
    ../programs/tmux.nix
    ../programs/ghostty.nix
    ../programs/git.nix
  ];

  home.file = {
    # Stable SDK symlinks
    "SDKs/Java/21".source = pkgs.jdk21.home;
  };
}
