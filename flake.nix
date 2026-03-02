{
  description = "girvel's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs self; };
        modules = [
          ./hosts/vm/default.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.girvel = import ./common/home.nix;
          }
        ];
      };

      iso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"

          ({ pkgs, config, ... }: {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.permittedInsecurePackages = [
              "broadcom-sta-6.30.223.271-59-6.12.62"
            ];

            boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
            boot.kernelModules = [ "wl" ];

            services.usbmuxd.enable = true;
            environment.systemPackages = with pkgs; [
              libimobiledevice
              ifuse
            ];

            hardware.enableAllFirmware = true;
            isoImage.squashfsCompression = "gzip -Xcompression-level 1";
          })
        ];
      };
    };
  };
}
