{ 
  console.keyMap = "de";
  services.keyd = {
    enable = true;
    keyboards.default.settings.main = {
      capslock = "esc";
      right = "noop"; # pressed by misbehaving thinkpad altgr
      leftmeta = "layer(alt)";
      leftalt = "layer(meta)";
    };
  };
}
