{ pkgs, inputs, system }: rec {
  install-iso = pkgs.callPackage ./install-iso {
    inherit system;
    inherit (pkgs) writeShellScriptBin;
    inherit (inputs) agenix nixos-generators;
  };
  default = install-iso;
}
