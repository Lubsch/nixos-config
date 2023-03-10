{ pkgs, ... }: {
  imports = [
    /* ./discord */
    /* ./spotify */
    ./gtk-qt.nix
    ./firefox.nix
    /* ./shotcut.nix */
    /* ./tor.nix */
    /* ./calibre.nix */
    /* ./abiword.nix */
  ];

  home.packages = with pkgs; [
    xdragon # Drag and drop from terminal
  ];


  keyboard = {
    layout = "de";
    options = "caps:escape";
  };

  xdg.mimeApps.enable = true;
}
