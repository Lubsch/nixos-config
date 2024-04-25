import os
import subprocess
import json

os.chdir(os.path.expanduser("~/misc/repos/nixos-config"))
os.system("git add .")

nix_cmd = ["nix", "eval", "--json", ".#nixosConfigurations", "--apply", "builtins.attrNames"]
systems = json.loads(subprocess.check_output(nix_cmd))
# TODO
# for system in systems:

# "check" makes script exit on falure
subprocess.run(["sudo", "nixos-rebuild", "switch", "--flake", "."], check=True)

os.system("git commit --allow-empty-message -m \"\"")
