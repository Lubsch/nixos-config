{ pkgs, inputs, format }:
inputs.nixos-generators.nixosGenerate {
  inherit (pkgs) system;
  inherit format;
  specialArgs = { inherit inputs; };
  modules = [
    ../nixos/common/misc.nix
    ../nixos/common/layout.nix
    ../nixos/common/nix.nix
    ../nixos/wireless.nix
    {
      isoImage.squashfsCompression = "gzip -Xcompression-level 1";
      kernelPackages = pkgs.linuxPackages_latest; # avoid downloading older kernel
      environment.systemPackages = with pkgs; [
        inputs.disko.packages.${pkgs.system}.disko
        (writeShellScriptBin "clone" ''
          git clone https://github.com/lubsch/nixos-config
          cd nixos-config
          nix develop .#shell
        '')
      ];
    }
  ];
}
