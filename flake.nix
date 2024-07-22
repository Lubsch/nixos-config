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

          vm = [
            ./nixos/filtered-common.nix
            ./nixos/experimental-drives.nix
            ./nixos/impermanence.nix
            {
              main-disk = "/dev/sda";
              nixpkgs.hostPlatform = "x86_64-linux";
              swap-size = 2;
              home-manager.users.lubsch.imports = [ ./home/common ];
            }
          ];

          graf = [
            ./nixos/bluetooth.nix
            ./nixos/common
            ./nixos/impermanence.nix
            ./nixos/wireless.nix
            ./nixos/desktop.nix
            ./nixos/wireshark.nix
            ./nixos/printing.nix
            ./nixos/screenlock.nix
            ./nixos/fingerprint.nix
            {
              programs.ydotool.enable = true;
              main-disk = "/dev/nvme0n1";
              swap-size = 32;
              home-manager.users.lubsch.imports = [
                # ./home/waybar.nix
                ./home/common
                ./home/desktop-common
                ./home/hyprland.nix
                ./home/nvim
                ./home/mail.nix
                ./home/syncthing.nix
                ./home/keepassxc.nix
                ./home/firefox.nix
                ./home/gpg.nix
                {
                  persist.directories = [ ".stack" ]; # until i get it to save to data dir
                }
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
                ./home/librewolf.nix
                ./home/gpg.nix
              ];
            }
          ];

          raja = [
            {
              services.openssh.ports = [ 22 ];
              users.users.lubsch.openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILT2hUBw9sDjvv+hlFuKrvu5wh13VGXLOPOJDVZBMc+N lubsch@shah"
              ];
            }
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
              main-disk = "/dev/nvme0n1";
              swap-size = 16;
              home-manager.users."lubsch".imports = [
                ./home/common
                ./home/desktop-common
                ./home/hyprland.nix
                ./home/nvim
                ./home/steam.nix
                ./home/mail.nix
                ./home/syncthing.nix
                ./home/keepassxc.nix
                ./home/librewolf.nix
                # ./home/waybar.nix
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
