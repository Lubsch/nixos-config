{ pkgs, nixos-generators }:
nixos-generators.nixosGenerate {
  system = "x86_64-linux";
  modules = [
    # you can include your own nixos configuration here, i.e.
    # ./configuration.nix
  ];
  format = "vmware";
  
  # you can also define your own custom formats
  # customFormats = { "myFormat" = <myFormatModule>; ... };
  # format = "myFormat";
};
