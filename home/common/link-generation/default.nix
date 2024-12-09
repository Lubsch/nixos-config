# this activation script was *slow* because it uses find
# I replace it with a simple zig program
# this cuts it down from ca. 300ms to ca. 30ms for that step
# NOTE it doesnt do backups and deletes files to override them
{ lib, pkgs, ... }:
let
  link = pkgs.runCommand "link" { } ''
    cp ${./link.zig} link.zig
    export XDG_CACHE_HOME=$(mktemp -d)
    ${pkgs.zig}/bin/zig build-exe link.zig -O ReleaseSafe
    cp link $out
  '';
in
{
  home.activation.linkGeneration = lib.mkForce (
    lib.hm.dag.entryAfter [ "writeBoundary" ] # bash
      ''
        function linkNewGen() {
          _i "Creating home file links in %s" "$HOME"

          local newGenFiles
          newGenFiles="$(readlink -e "$newGenPath/home-files")"
          find "$newGenFiles" \( -type f -or -type l \) \
            -exec ${link} "$newGenFiles" {} +
        }

        function cleanOldGen() {
          if [[ ! -v oldGenPath || ! -e "$oldGenPath/home-files" ]] ; then
            return
          fi

          _i "Cleaning up orphan links from %s" "$HOME"

          local newGenFiles oldGenFiles
          newGenFiles="$(readlink -e "$newGenPath/home-files")"
          oldGenFiles="$(readlink -e "$oldGenPath/home-files")"

          # Apply the cleanup script on each leaf in the old
          # generation. The find command below will print the
          # relative path of the entry.
          find "$oldGenFiles" '(' -type f -or -type l ')' -printf '%P\0' \
            | xargs -0 bash /nix/store/s9p3c8fwpjnzdkyky4qbdfg339yqrb9a-cleanup "$newGenFiles"
        }

        cleanOldGen

        echo genProfilePath: $genProfilePath

        if [[ ! -v oldGenPath || "$oldGenPath" != "$newGenPath" ]] ; then
          _i "Creating profile generation %s" $newGenNum
          if [[ -e "$genProfilePath"/manifest.json ]] ; then
            # Remove all packages from "$genProfilePath"
            # `nix profile remove '.*' --profile "$genProfilePath"` was not working, so here is a workaround:
            nix profile list --profile "$genProfilePath" \
              | cut -d ' ' -f 4 \
              | xargs -rt $DRY_RUN_CMD nix profile remove $VERBOSE_ARG --profile "$genProfilePath"
            run nix profile install $VERBOSE_ARG --profile "$genProfilePath" "$newGenPath"
          else
            run nix-env $VERBOSE_ARG --profile "$genProfilePath" --set "$newGenPath"
          fi

          run --quiet nix-store --realise "$newGenPath" --add-root "$newGenGcPath" --indirect
          if [[ -e "$legacyGenGcPath" ]]; then
            run rm $VERBOSE_ARG "$legacyGenGcPath"
          fi
        else
          _i "No change so reusing latest profile generation %s" "$oldGenNum"
        fi

        linkNewGen
      ''
  );
}
