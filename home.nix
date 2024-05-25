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
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run
    hello
    neofetch
    htop

    nodejs_20
    netlify-cli
    yarn
    go

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (nerdfonts.override { fonts = [ "FiraCode" ]; })

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
      homec = "vim ~/.config/home-manager/home.nix";
      homes = "home-manager switch";
      nixc = "sudo vim /etc/nixos/configuration.nix";
      nixs = "sudo nixos-rebuild switch";
      devinit = "nix flake init --template github:cachix/devenv";
    };
    initExtra = ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      bindkey  "^[[H"   beginning-of-line
      bindkey  "^[[F"   end-of-line
      bindkey  "^[[3~"  delete-char
    '';

    enableAutosuggestions = true;
    historySubstringSearch.enable = true;
    zplug = {
      enable = true;
      plugins = [
        { name = "plugins/git"; tags = [from:oh-my-zsh]; }
        { name = "zsh-users/zsh-completions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; tags = [defer:2]; }
        { name = "mafredri/zsh-async"; tags = [from:github]; }
        { name = "sindresorhus/pure"; tags = [use:pure.zsh from:github as:theme]; }
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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

