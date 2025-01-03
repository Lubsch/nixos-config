{
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
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # roc-lang = {
    #   url = "github:roc-lang/roc";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs: {
    inherit inputs;
    templates = import ./templates;
    packages = import ./pkgs inputs;

    nixosConfigurations =
      builtins.mapAttrs
        (
          name: modules:
          inputs.nixpkgs.lib.nixosSystem {
            modules = modules ++ [
              ((p: if builtins.pathExists p then p else { }) ./generated/${name}.nix)
              { networking.hostName = name; }
            ];
            specialArgs = {
              inherit inputs;
            };
          }
        )
        {

          graf = [
            ./nixos/bluetooth.nix
            ./nixos/common
            ./nixos/impermanence.nix
            ./nixos/wireless.nix
            ./nixos/desktop.nix
            # ./nixos/wireshark.nix
            # ./nixos/printing.nix
            ./nixos/screenlock.nix
            # ./nixos/fingerprint.nix
            {
              main-disk = "/dev/nvme0n1";
              swap-size = 32;
              home-manager.users.lubsch.imports = [
                ./home/common
                ./home/desktop-common
                ./home/hyprland.nix
                ./home/river.nix
                ./home/nvim
                ./home/mail.nix
                # ./home/syncthing.nix
                ./home/keepassxc.nix
                ./home/firefox.nix
                ./home/gpg.nix
                ./home/waybar.nix
              ];
            }
          ];

          raja = [
            ./nixos/common
            ./nixos/impermanence.nix
            ./nixos/wireless.nix
            ./nixos/printing.nix
            ./nixos/desktop.nix
            ./nixos/bluetooth.nix
            ./nixos/screenlock.nix
            ./nixos/printing.nix
            # ./nixos/droidcam.nix
            ./nixos/wireguard.nix
            {
              fileSystems."/data" = {
                device = "/dev/sdb1";
                fsType = "ext4";
                options = [ "noatime" ];
              };
              main-disk = "/dev/nvme0n1";
              swap-size = 16;
              home-manager.users."lubsch".imports = [
                ./home/common
                ./home/desktop-common
                ./home/river.nix
                ./home/hyprland.nix
                ./home/nvim
                ./home/steam.nix
                ./home/mail.nix
                ./home/syncthing.nix
                ./home/keepassxc.nix
                ./home/firefox.nix
                # ./home/gpg.nix
                ./home/waybar.nix
              ];
            }
          ];

          shah = [
            ./nixos/common
            ./nixos/impermanence.nix
            ./nixos/wireless.nix
            ./nixos/desktop.nix
            ./nixos/wireshark.nix
            ./nixos/printing.nix
            ./nixos/screenlock.nix
            {
              main-disk = "/dev/sda";
              swap-size = 8;
              services.keyd.keyboards.default.settings.main.right = "noop"; # sees altgr as right
              home-manager.users.lubsch.imports = [
                ./home/common
                ./home/desktop-common
                ./home/hyprland.nix
                ./home/nvim
                ./home/mail.nix
                ./home/syncthing.nix
                ./home/keepassxc.nix
                # ./home/librewolf.nix
                ./home/gpg.nix
              ];
            }
          ];

          serf = [
            ./nixos/common
            ./nixos/impermanence.nix
            ./nixos/backups.nix
            ./nixos/wireless.nix
            { main-disk = "/dev/sda"; }
          ];
        };
  };
}
