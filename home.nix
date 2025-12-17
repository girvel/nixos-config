{ config, pkgs, ... }: {
  home.username = "girvel";
  home.homeDirectory = "/home/girvel";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [];
}
