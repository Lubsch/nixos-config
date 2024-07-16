inputs:
builtins.mapAttrs (system: pkgs: {
  iso = pkgs.callPackage ./iso.nix { inherit inputs; };
  shell = pkgs.callPackage ./shell.nix { inherit inputs; };
  nvim = pkgs.callPackage ./nvim-hacky.nix { inherit inputs; };
  nvim-dap-rr = pkgs.callPackage ./nvim-dap-rr.nix { };
  vimium = pkgs.callPackage ./vimium { inherit inputs; };
  vm = import "${inputs.nixpkgs}/nixos/lib/make-disk-image.nix" {
    inherit pkgs;
    inherit (pkgs) lib;
    config =
      (inputs.nixpkgs.lib.nixosSystem {
        inherit pkgs;
        modules = [
          {
            boot.loader.grub.devices = [ "/dev/vda" ];
            fileSystems = {
              "/" = {
                fsType = "ext4";
                device = "/dev/vda";
              };
            };
            system.stateVersion = "23.05";
          }
        ];
      }).config;
    diskSize = 10240;
    format = "qcow2";
  };
}) inputs.nixpkgs.legacyPackages
