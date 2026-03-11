{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/system.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  # Drivers for Broadcom Wi-Fi module
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.kernelModules = [ "wl" ];
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.12.62"
  ];

  networking.hostName = "niflheim1";
}
