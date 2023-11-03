inputs:
builtins.mapAttrs (system: pkgs: {
  iso = pkgs.callPackage ./iso.nix { inherit inputs; format = "install-iso"; };
  iso-sd = pkgs.callPackage ./iso.nix { inherit inputs; format = "sd-aarch64-installer"; };
  shell = pkgs.callPackage ./shell.nix { inherit inputs; };
  nvim = pkgs.callPackage ./nvim-hacky.nix { inherit inputs; };
  mi-engine = pkgs.callPackage ./mi-engine {};
  nvim-dap-rr = pkgs.callPackage ./nvim-dap-rr.nix {};
}) inputs.nixpkgs.legacyPackages
