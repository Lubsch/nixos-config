{
  console.keyMap = "de";
  services.keyd = {
    enable = true;
    keyboards = {
      default.settings.main = {
        capslock = "esc";
        leftmeta = "layer(alt)";
        leftalt = "layer(meta)";
      };
    };
  };
}
