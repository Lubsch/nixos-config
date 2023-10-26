{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    disko = { url = "github:nix-community/disko"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-generators = { url = "github:nix-community/nixos-generators"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-gaming = { url = "github:fufexan/nix-gaming"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs: {
    inherit inputs;
    templates = import ./templates;
    packages = import ./pkgs inputs;

    nixosConfigurations = builtins.mapAttrs (name: modules: inputs.nixpkgs.lib.nixosSystem {
      modules =  modules ++ [ { networking.hostName = name; } ];
      specialArgs = { inherit inputs; };
    }) {

      shah = [
        ./nixos/common
        ./nixos/wireless.nix
        ./nixos/desktop.nix
        ./nixos/bluetooth.nix
        # ./nixos/virtualisation.nix
        ./nixos/printing.nix
        {
          impermanence = true;
          services.keyd.keyboards.default.settings.main.right = "noop";
          nixpkgs.hostPlatform = "x86_64-linux";
          main-disk = "/dev/sda";
          swap = { size = 8; offset = "2106624"; };
          hardware.cpu.intel.updateMicrocode = true;
          boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "sd_mod" "sdhci_pci" ];
          boot.kernelModules = [ "kvm-intel" ];
          home-manager.users.lubsch.imports = [
            ./home/common
            ./home/desktop-common
            ./home/hyprland.nix
            # ./home/yambar.nix
            # ./home/helix.nix
            ./home/nvim.nix
            ./home/mail.nix
            ./home/syncthing.nix
            ./home/keepassxc.nix
            ./home/qutebrowser.nix
          ];
        } ];

      raja = [
          ./nixos/common
          ./nixos/wireless.nix
          ./nixos/desktop.nix
          ./nixos/bluetooth.nix
          # ./nixos/virtualisation.nix
          {
            impermanence = true;
            nixpkgs.hostPlatform = "x86_64-linux";
            main-disk = "/dev/nvme0n1";
            swap = { size = 16; offset = "1626837"; };
            hardware.cpu.amd.updateMicrocode = true;
            boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
            boot.kernelModules = [ "kvm-amd" ];
            home-manager.users."lubsch".imports = [
              ./home/common
              ./home/desktop-common
              ./home/hyprland.nix
              # ./home/yambar.nix
              ./home/nvim.nix
              ./home/steam.nix
              ./home/mail.nix
              ./home/syncthing.nix
              ./home/keepassxc.nix
              ./home/qutebrowser.nix
            ];
          } ];

    };
  };
}
