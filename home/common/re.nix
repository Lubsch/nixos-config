{ pkgs, ... }: {
  # re script which used to be a shell alias - a "deployment tool"
  # - Regenerates and garbage collects files in generated
  # - Rebuilds nixos system
  # - Commits if successful (with empty message)


  home.packages = with pkgs; [
    (writeScriptBin "re" /*python*/ ''
      #!${pkgs.python3}

      import os
      import subprocess
      import json

      os.chdir(os.path.expanduser("~/misc/repos/nixos-config"))
      os.system("git add .")

      nix_cmd = [ "nix" "eval" "--json" ".#nixosConfigurations" "--apply" "builtins.attrNames" ]
      systems = json.loads(subprocess.check_output(nix_cmd))
      for system in systems:
        print(system)

      os.system("sudo nixos-rebuild switch --flake . || exit")
      os.system("git commit --allow-empty-message -m \"\"")
    '')
  ];
}
