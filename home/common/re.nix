{ pkgs, ... }: {
  # re script which used to be a shell alias - a "deployment tool"
  # - Regenerates and garbage collects files in generated
  # - Rebuilds nixos system
  # - Commits if successful (with empty message)


  home.packages = [
    (pkgs.writeShellScriptBin "re" /*bash*/ ''
      cd ~/misc/repos/nixos-config
      git add .

      systems=$(nix eval --json .#nixosConfigurations --apply builtins.attrNames  | jq -c '.[]')
      for system in $systems; do
        echo $system
      done

      sudo nixos-rebuild switch --flake . || exit
      git commit --allow-empty-message -m ""
    '')
  ];
}
