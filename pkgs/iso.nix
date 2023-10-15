{ pkgs, inputs }:
inputs.nixos-generators.nixosGenerate {
  inherit (pkgs) system;
  format = "install-iso";
  specialArgs = { inherit inputs; };
  modules = [
    ../nixos/common/layout.nix
    ../nixos/common/nix.nix
    ../nixos/wireless.nix
    ../nixos/common/misc.nix
    ../nixos/common/doas.nix
    {
      environment.systemPackages = with pkgs; [
        inputs.disko.packages.${pkgs.system}.disko
        (writeShellScriptBin "clone" ''
          git clone https://github.com/lubsch/nixos-config
          cd nixos-config
          nix shell .#shell
        '')
      ];
    }
  ];
}