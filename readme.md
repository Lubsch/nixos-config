# NixOS-config

This is my NixOS-config.

## How it works

This config makes use of a lot of NixOS features.

Secrets:

- Each host has its own private hostkey, saved in (/persist)/etc/ssh/ssh_host_ed25519_key (set in ./hosts/common/global/openssh.nix)
- This hostkey is used to decrypt secrets stored in the ./hosts/common/global/secrets.yaml file and the ./hosts/{hostname}/secrets.yaml files
- This behavior is defined in the file ./hosts/common/global/sops.nix

SSH:

- The file ./hosts/common/users/lubsch.nix defines authorizedKeys, which are public ssh keys that can access the lubsch user from anywhere
- All ssh private keys are are of course only stored on a single host only (in the ~/.shh folder, except for hostkeys)

Colors:

- Color are managed using the module nix-colors by misterio which allows easy access to base16 colorschemes
