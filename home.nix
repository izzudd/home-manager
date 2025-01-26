{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "izzudd";
  home.homeDirectory = "/home/izzudd";

  nixpkgs.config.allowUnfree = true;
  targets.genericLinux.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run
    hello
    pfetch
    htop
    speedtest-cli

    nodejs_22
    bun
    netlify-cli
    yarn-berry

    go

    uv

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (nerdfonts.override { fonts = [ "FiraCode" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # devenv
    (import (fetchTarball https://install.devenv.sh/latest)).default
  ];

  programs.git = {
    enable = true;
    userName = "izzudd";
    userEmail = "36723840+izzudd@users.noreply.github.com";
  };
  programs.vim = {
    enable = true;
    extraConfig = ''
      set autoindent
      set smartindent
      set shiftwidth=2
    '';
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };
  programs.fzf.enable = true;
  programs.zsh = {
    enable = true;
    shellAliases = {
      homec          = "vim ~/.config/home-manager/home.nix";
      homes          = "home-manager switch";
      nixup          = "nix-channel --update";
      nixc           = "sudo vim /etc/nixos/configuration.nix";
      nixs           = "sudo nixos-rebuild switch";
      devinit        = "nix flake init --template github:cachix/devenv";
      docker-start   = "sudo systemctl start docker";
      docker-stop    = "sudo systemctl stop docker";
      docker-clean   = "docker system prune -a";
      docker-killall = "docker stop $(docker ps -a -q)";
    };
    initExtra = ''
      PF_INFO="ascii title os host kernel uptime memory" pfetch
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      
      bindkey "^[[H"    beginning-of-line
      bindkey "^[[F"    end-of-line
      bindkey "^[[3~"   delete-char
      bindkey "\e[1;5D" backward-word
      bindkey "\e[1;5C" forward-word
      bindkey '^H'      backward-kill-word
      bindkey '5~'      kill-word

      bindkey '^[[A' history-substring-search-up
      bindkey '^[OA' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      bindkey '^[OB' history-substring-search-down

      source ~/.config/home-manager/p10k.zsh
      source ~/.bashrc
    '';

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-completions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; tags = [defer:2]; }
        { name = "zsh-users/zsh-history-substring-search"; }
        { name = "mafredri/zsh-async"; tags = [from:github]; }
        { name = "romkatv/powerlevel10k"; tags = [depth:1 as:theme]; }
      ];
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/izzudd/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
    LC_ALL = "C";
    LANG = "C.UTF-8";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

