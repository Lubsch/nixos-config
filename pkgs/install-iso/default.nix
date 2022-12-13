{ nixos-generators, system, home-manager, git, age, ssh-to-age, sops }:
nixos-generators.nixosGenerate {
  inherit system;
  format = "install-iso";
  modules = [{
    networking.networkmanager.enable = true;
    users.users.nixos.extraGroups = [ "networkmanager" ];
    console.keyMap = "de";
    environment.systemPackages = [
      home-manager
      git
      age
      ssh-to-age
      sops
    ];
    nix.settings.extraOptions = ''
      experimental-features = nix-command flakes
    '';
  }];
}
