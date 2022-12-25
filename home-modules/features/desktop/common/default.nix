{ pkgs, ... }: {
  imports = [
    ./discord
    ./spotify
    ./librewolf.nix
    ./font.nix
    ./gtk.nix
    ./qt.nix
    ./shotcut.nix
    ./tor.nix
    ./calibre.nix
    ./abiword.nix
  ];

  home.packages = with pkgs; [
    xdragon # Drag and drop
  ];

  xdg.mimeApps.enable = true;
}
