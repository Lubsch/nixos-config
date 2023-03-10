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

  # Program that auto-detects font on system
  fonts.fonconfig.enable = true;

  keyboard = {
    layout = "de";
    options = "caps:escape";
  };

  xdg.mimeApps.enable = true;
}
