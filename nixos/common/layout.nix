let
  default =  {
    capslock = "esc";
    leftmeta = "layer(alt)";
    leftalt = "layer(meta)";
  };
in {
  console.keyMap = "de";
  services.keyd = {
    enable = true;
    keyboards = {
      default.settings.main = default;
      "0fac:0ade".settings.main = default // { 
        right = "noop"; # pressed by misbehaving thinkpad altgr 
      };
    };
  };
}
