{ lib, ... }: {
  imports = with lib; remove ./default.nix (filesystem.listFilesRecursive ./.);
}
