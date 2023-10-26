builtins.mapAttrs 
  (n: _: { description = n; path = ./. + "/${n}"; })
  (builtins.readDir ./.)
