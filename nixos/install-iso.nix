{ pkgs, nixpkgs, ... }:
(nixpkgs.lib.nixosSystem {
  system = pkgs.system;
  modules = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    ./common/layout.nix
    ./common/doas.nix
    ({
      networking.wireless.iwd.enable = true;
      networking.wireless.enable = false;
      nix.extraOptions = "experimental-features = nix-command flakes repl-flake";
      users.users.root.password = "installate";
      environment.systemPackages = with pkgs; [ git ];
    })
  ];
}).config.system.build.isoImage
