{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    disko = { url = "github:nix-community/disko"; inputs.nixpkgs.follows = "nixpkgs"; };
    proton-ge = {
      url = "https://raw.githubusercontent.com/Shawn8901/nix-configuration/main/packages/proton-ge-custom/default.nix";
      flake = false;
    };
  };

  outputs = inputs: with inputs.nixpkgs; with builtins; {

    templates = mapAttrs (n: _: { description = n; path = ./templates + "/${n}"; }) (readDir ./templates);

    packages = mapAttrs (system: pkgs: { 
      disko = inputs.disko.packages.${system}.disko;
      nvim-lsp = pkgs.callPackage ./home/nvim/package.nix { lsp = true; };
      nvim = pkgs.callPackage ./home/nvim/package.nix { lsp = false; };
    }) legacyPackages;

    nixosConfigurations = mapAttrs (name: modules: lib.nixosSystem {
      modules =  modules ++ [ { networking.hostName = name; } ];
      specialArgs = { inherit inputs; };
    }) {

      shah = [
        ./nixos/common
        ./nixos/impermanence.nix
        ./nixos/wireless.nix
        ./nixos/desktop.nix
        ./nixos/bluetooth.nix
        ./nixos/virtualisation.nix
        ./nixos/printing.nix
      {
        nixpkgs.hostPlatform = "x86_64-linux";
        main-disk = "/dev/disk/by-id/wwn-0x5002538d42cb6a60";
        swap = { size = 8; offset = "1844480"; };
        hardware.cpu.intel.updateMicrocode = true;
        boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "sd_mod" "sdhci_pci" ];
        boot.kernelModules = [ "kvm-intel" ];
        home-manager.users.lubsch.imports = [
          ./home/common
          ./home/desktop-common
          ./home/hyprland.nix
          # ./home/yambar.nix
          ./home/nvim
          ./home/mail.nix
          ./home/syncthing.nix
          ./home/keepassxc.nix
          ./home/qutebrowser.nix
        ];
      } ];

    };
  };
}
