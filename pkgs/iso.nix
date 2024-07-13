{
  inputs,
  system,
  writeShellScriptBin,
}:
(inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = {
    inherit inputs;
  };
  modules = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    ../nixos/common/misc.nix
    ../nixos/common/layout.nix
    ../nixos/common/nix.nix
    ../nixos/wireless.nix
    {
      isoImage.squashfsCompression = "gzip -Xcompression-level 1";
      environment.systemPackages = [
        inputs.disko.packages.${system}.disko
        (writeShellScriptBin "clone" ''
          git clone https://github.com/lubsch/nixos-config
          cd nixos-config
          nix develop .#shell
        '')
      ];
    }
  ];
}).config.system.build.isoImage
