{ pkgs, ... }: {
  imports = map (n: ./. + "/${n}")
    (builtins.filter
      (n: n != "default.nix")
      (builtins.attrNames (builtins.readDir ./.)));

  home = {
    packages = with pkgs; [
      swaybg
      xdragon # Drag and drop from terminal
      brightnessctl # Change brightness
    ];
  };

  xdg.mimeApps.enable = true;
}
