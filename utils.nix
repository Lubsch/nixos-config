{ inputs, outputs }: {

  mkSystems = configs:
    builtins.mapAttrs (name: modules: inputs.nixpkgs.lib.nixosSystem {
      modules = modules ++ [ 
        ((p: if builtins.pathExists p then p else {}) ./generated/${name}.nix)
        { networking.hostName = name; }
      ];
      specialArgs = { inherit inputs outputs; };
    })
    configs;

}
