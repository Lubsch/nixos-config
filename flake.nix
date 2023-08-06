{
  description = "Lubsch's NixOS and Home-Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = { 
      url = "github:nix-community/home-manager"; 
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: with nixpkgs; with builtins; {

    templates = mapAttrs (n: _: { description = n; path = ./templates + "/${n}"; }) (readDir ./templates);

    packages = mapAttrs (system: pkgs: rec { 
      disko = inputs.disko.outputs.packages.${system}.disko;
      install = pkgs.writeShellScriptBin "install" ''
        ${disko}/bin/disko -m disko -f git+file:${self.outPath}#"$1"
        nixos-install --flake ${self.outPath}#"$1" --no-root-password
      '';
    } // import ./home/nvim/package.nix pkgs) legacyPackages;

    nixosConfigurations = mapAttrs (hostname: {
      system ? "x86_64-linux",
      main-disk,
      cpuVendor ? "",
      impermanence ? true,
      initrdModules ? [],
      kernelModules ? [],
      swap ? { size = null; offset = ""; },
      modules,
      users ? {}
    }: lib.nixosSystem {
      inherit system modules;
      specialArgs = { inherit inputs hostname main-disk impermanence kernelModules initrdModules swap users cpuVendor; };
    }) {

      "shah" = {
        main-disk = "/dev/sda";
        cpuVendor = "intel";
        initrdModules = [ "ehci_pci" "ahci" "sd_mod" "sdhci_pci" ];
        kernelModules = [ "kvm-intel" ];
        swap = { size = 8; offset = "1844480"; };
        modules = [
          ./nixos/common
          ./nixos/wireless.nix
          ./nixos/desktop.nix
          ./nixos/zsh.nix
          ./nixos/bluetooth.nix
        ];
        users."lubsch" = [
          ./home/common
          ./home/nvim
          ./home/desktop-common
          ./home/hyprland.nix
          ./home/mail.nix
          ./home/syncthing.nix
          ./home/keepassxc.nix
          ./home/qutebrowser.nix
        ];
      };

      "duke" = {
        main-disk = "/dev/sda";
        cpuVendor = "intel";
        initrdModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
        kernelModules = [ "kvm-intel" ];
        swap = { size = 8; offset = "1256037"; };
        modules = [
          ./nixos/common
          ./nixos/wireless.nix
          ./nixos/desktop.nix
          ./nixos/zsh.nix
          ./nixos/bluetooth.nix
        ];
        users."lubsch" = [
          ./home/common
          ./home/nvim
          ./home/desktop-common
          ./home/hyprland.nix
          ./home/mail.nix
          ./home/syncthing.nix
          ./home/keepassxc.nix
          ./home/qutebrowser.nix
        ];
      };

    };
  };
}
