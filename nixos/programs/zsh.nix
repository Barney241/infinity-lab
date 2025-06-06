{ config, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autosuggestion.enable = true;
    # enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      #list
      ls = "ls -la --color=auto";
      #fix obvious typo"s
      "cd.." = "cd ..";
      ## Colorize the grep command output for ease of use (good for log files)##
      grep = "grep --color=auto";
      #readable output
      df = "df -h";
      #continue download
      wget = "wget -c";
      # tmux
      ta = "tmux attach -t";
      ts = "tmux new -s";
      # nix
      ns = "nix-shell shell.nix";
      nd = "nix develop";
      nixos-full-upgrade =
        "sudo nix flake update && nix-collect-garbage && sudo nixos-rebuild switch";
      # kubectl
      k = "kubectl";

      tms = "sh ~/.tmux/sessionizer/sessionizer.sh";
    };

    # initExtra = ''
    #   eval "$(starship init zsh)"
    # '';

    oh-my-zsh = {
      enable = true;

      plugins = [
        "git"
        "fzf"
        # "history-substring-search"
        "colored-man-pages"
        # "zsh-autosuggestions"
        "z"
        "tmux"
        "docker"
        "kubectl"
        # "ssh-agent"
      ];
    };
    plugins = with pkgs; [
      {
        name = "zsh-syntax-highlighting";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.6.0";
          sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
        };
        file = "zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-spaceship-prompt";
        src = fetchFromGitHub {
          owner = "spaceship-prompt";
          repo = "spaceship-prompt";
          rev = "v4.15.0";
          hash = "sha256-QCaZCSgg5BF8d2IIatkDBbVBL5CpzwoF94qfu2e4zTo=";
        };
        file = "spaceship.zsh-theme";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];
  };

  programs.zellij = {
    # TODO enable
    enable = false;
    # enableZshIntegration = true;
  };

  # Environment
  # sessionVariables = {
  #   HISTCONTROL = "ignoreboth:erasedups";
  #   ZSH_THEME = "spaceship";
  # };

  # programs.starship = {
  #   enable = false;
  #   # Configuration written to ~/.config/starship.toml
  #   settings = {
  #     # add_newline = false;
  #
  #     # character = {
  #     #   success_symbol = "[➜](bold green)";
  #     #   error_symbol = "[➜](bold red)";
  #     # };
  #
  #     # package.disabled = true;
  #   };
  # };
  #
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
