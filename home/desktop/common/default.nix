{ pkgs, ... }: {
  imports = [
    /* ./discord */
    /* ./spotify */
    ./gtk-qt.nix
    ./firefox.nix
    ./foot.nix
    ./fonts.nix
    /* ./shotcut.nix */
    /* ./tor.nix */
    /* ./calibre.nix */
    /* ./abiword.nix */
  ];

  home = {
    packages = with pkgs; [
      xdragon # Drag and drop from terminal
    ];
  };

  xdg.mimeApps.enable = true;
}
