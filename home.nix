{ config, pkgs, lib, ... }: {
  home.username = "girvel";
  home.homeDirectory = "/home/girvel";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    stow
    nodejs_22
    gh
    ghostty
  ];

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
