{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yambar
    (pkgs.rustPlatform.buildRustPackage rec {
      name = "yambar-hyprland-wses";
      version = "unstable-2023-07";

      cargoSha256 = pkgs.lib.fakeSha256;

      src = pkgs.fetchFromGitHub {
        owner = "jonhoo";
        repo = name;
      };
    })
  ];
}
