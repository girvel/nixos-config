{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/system.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  virtualisation.virtualbox.guest.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      ghostty = prev.symlinkJoin {
        name = "ghostty";
        paths = [ prev.ghostty ];
        buildInputs = [ prev.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/ghostty --set LIBGL_ALWAYS_SOFTWARE 1
        '';
      };
    })
  ];
}
