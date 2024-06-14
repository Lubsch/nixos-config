import os
import subprocess
import json

# suppress python exception output
try:
    os.chdir(os.path.expanduser("~/misc/repos/nixos-config"))
    os.system("git add .")

    nix_cmd = ["nix", "eval", "--json", ".#nixosConfigurations", "--apply", "builtins.attrNames"]
    systems = json.loads(str(subprocess.check_output(nix_cmd)))
    # TODO
    # for system in systems:

    # "check" makes script exit on falure
    subprocess.run(["sudo", "nixos-rebuild", "switch", "--flake", "."])

    os.system("git commit --allow-empty-message -m \"\"")
    os.system("git push")
except:
    pass
