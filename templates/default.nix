with builtins; mapAttrs (n: _: { description = n; path = ./.+"/"+n; }) (readDir ./.);
