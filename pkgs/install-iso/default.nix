{ magic-wormhole, writeShellScriptBin, nixos-generators, system, home-manager, git, rage, agenix }:
nixos-generators.nixosGenerate {
  inherit system;
  format = "install-iso";
  modules = [{
    networking.networkmanager.enable = true;
    networking.wireless.enable = false;
    users.users.nixos.extraGroups = [ "networkmanager" ];
    console.keyMap = "de";
    environment.systemPackages = [
      home-manager
      git
      agenix
      rage
      magic-wormhole
      (writeShellScriptBin "setup" (builtins.readFile ./setup.sh))
    ];
    nix.settings.extraOptions = ''
      experimental-features = nix-command flakes
    '';
  }];
}
