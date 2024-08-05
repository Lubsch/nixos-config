import os
import subprocess
# import json

# suppress python exception output
try:
    os.chdir(os.path.expanduser("~/misc/repos/nixos-config"))
    subprocess.run(["nixfmt", "."])
    subprocess.run(["git", "add", "."])

    # nix_cmd = ["nix", "eval", "--json", ".#nixosConfigurations", "--apply", "builtins.attrNames"]
    # systems = json.loads(subprocess.check_output(nix_cmd))
    # TODO
    # for system in systems:

    # "check" makes script exit on falure
    subprocess.run(["sudo", "nixos-rebuild", "switch", "--flake", "."], check=True)

    child_pid = os.fork()

    if child_pid == 0:
        subprocess.run(["git", "commit", "--allow-empty-message", "-m", ""], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        subprocess.run(["git", "push"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
except:
    pass
