inputs:
builtins.mapAttrs (system: pkgs: { 
  iso = pkgs.callPackage ./pkgs/iso.nix { inherit inputs; };
  shell = pkgs.callPackage ./pkgs/shell.nix { inherit inputs; };
  nvim = pkgs.callPackage ./pkgs/nvim { lsp = false; };
  nvim-lsp = pkgs.callPackage ./pkgs/nvim { lsp = true; };
}) inputs.nixpkgs.legacyPackages
