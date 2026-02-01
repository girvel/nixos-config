{ config, pkgs, lib, ... }: {
  home.username = "girvel";
  home.homeDirectory = "/home/girvel";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    stow
    nodejs_22
    ghostty
    fd
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
    };

    initExtra = ''
      source ~/.aliases
      source ~/.oh-my-zsh/themes/arch.zsh-theme
    '';

    sessionVariables = {
      EDITOR = "nvim";
      WORKSHOP = "$HOME/workshop";
    };
  };

  home.activation.stowDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    DOTFILES_DIR="${config.home.homeDirectory}/workshop/nixos-config/dotfiles"
    if [ -d "$DOTFILES_DIR" ]; then
      echo "Stowing dotfiles from $DOTFILES_DIR..."
      ${pkgs.stow}/bin/stow --dir="$DOTFILES_DIR" --target="${config.home.homeDirectory}" --restow .
    else
      echo "[ERROR] dotfiles not found at $DOTFILES_DIR"
    fi
  '';
}
