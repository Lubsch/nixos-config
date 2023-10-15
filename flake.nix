{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    disko = { url = "github:nix-community/disko"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-generators = { url = "github:nix-community/nixos-generators"; inputs.nixpkgs.follows = "nixpkgs"; };
    proton-ge = {
      url = "https://raw.githubusercontent.com/Shawn8901/nix-configuration/main/packages/proton-ge-custom/default.nix";
      flake = false;
    };
  };


  outputs = inputs: with inputs.nixpkgs; with builtins;
  let
    mylib = rec {
      # Returns a list of regular files in a directory
      getDir = dir: map (n: dir + "/${n}") (builtins.attrNames (lib.filterAttrs (_: t: t == "regular") (builtins.readDir dir)));
      importDir = dir: { imports  = getDir dir; };
      optionalizeModule = name: m: {
        options = { "${n}".enable = lib.mkEnableOption;  } // m.options;
        config = builtins.removeAttrs m [ "options" ];
      };
      importDirOptionalized = dir: lib.mapAttrsToList
        (name: type: if type == "regular"
          then mylib.optionalizeModule (import dir + "/${name}")
          else mylib.optionalizeModule (mylib.importDir dir + "/${name}"))
        (readDir dir);
    };
  in {
    inherit inputs;
    inherit mylib;

    templates = mapAttrs (n: _: { description = n; path = ./templates + "/${n}"; }) (readDir ./templates);

    packages = mapAttrs (system: pkgs: { 
      iso = pkgs.callPackage ./pkgs/iso.nix { inherit inputs; };
      shell = pkgs.callPackage ./pkgs/shell.nix { inherit inputs; };
      nvim = pkgs.callPackage ./pkgs/nvim { lsp = false; };
      nvim-lsp = pkgs.callPackage ./pkgs/nvim { lsp = true; };
    }) legacyPackages;

    nixosConfigurations = mapAttrs (name: config: lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = mylib.importDirOptionalized ./nixos ++ [
        config
        {
          networking.hostName = name;
          home-manager.sharedModules = myLib.importOptionalized ./home;
        }
      ];
    }) {

      shah = [
        (mylib.importDir ./nixos/common)
        ./nixos/impermanence.nix
        ./nixos/wireless.nix
        ./nixos/desktop.nix
        ./nixos/bluetooth.nix
        # ./nixos/virtualisation.nix
        ./nixos/printing.nix
        {
          nixpkgs.hostPlatform = "x86_64-linux";
          main-disk = "/dev/sda";
          swap = { size = 8; offset = "2106624"; };
          hardware.cpu.intel.updateMicrocode = true;
          boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "sd_mod" "sdhci_pci" ];
          boot.kernelModules = [ "kvm-intel" ];
          home-manager.users.lubsch.imports = [
            (mylib.importDir ./home/common)
            (mylib.importDir ./home/desktop-common)
            ./home/hyprland.nix
            # ./home/yambar.nix
            ./home/nvim.nix
            ./home/mail.nix
            ./home/syncthing.nix
            ./home/keepassxc.nix
            ./home/qutebrowser.nix
          ];
        } ];

      raja = [
          (mylib.importDir ./nixos/common)
          ./nixos/impermanence.nix
          ./nixos/wireless.nix
          ./nixos/desktop.nix
          ./nixos/bluetooth.nix
          {
            nixpkgs.hostPlatform = "x86_64-linux";
            main-disk = "/dev/nvme0n1";
            swap = { size = 16; offset = "1626837"; };
            hardware.cpu.amd.updateMicrocode = true;
            boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
            boot.kernelModules = [ "kvm-amd" ];
            home-manager.users."lubsch".imports = [
                (mylib.importDir ./home/common)
                (mylib.importDir ./home/desktop-common)
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
