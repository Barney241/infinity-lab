{ config, lib, pkgs, ... }: {
  home.file.".tmux/sessionizer".source = (pkgs.fetchFromGitHub {
    owner = "Barney241";
    repo = "tmux-sessionizer";
    rev = "b0cbb866c66cae6658faefbe40fe4aebeb25fbd4";
    hash = "sha256-Faq+AlE4Pey+tWZqeZ0fx+mVpcVI3VQNqOWVe4QvueE=";
  });
  home.file.".tmux.conf".source = ./tmux/config;
}

