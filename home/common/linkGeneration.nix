# this activation script is *slow* because it uses find
# I replace it with rsync
{ lib, pkgs, config, ... }:
{
  # home.activation.linkGeneration = lib.mkForce (lib.hm.dag.entryAfter ["writeBoundary"] # bash
  # ''
  #   function linkNewGen() {
  #     _i "Creating home file links in %s" "$HOME"
  #
  #     local newGenFiles
  #     newGenFiles="$(readlink -e "$newGenPath/home-files")"
  #     ${pkgs.rsync}/bin/rsync --links --recursive "$newGenFiles"/ "$HOME"
  #     # find "$newGenFiles" \( -type f -or -type l \) \
  #     #   -exec bash /nix/store/1lc5w7q6nw7f2h760pgi1qvfg8r30ghw-link "$newGenFiles" {} +
  #   }
  #
  #   function cleanOldGen() {
  #     if [[ ! -v oldGenPath || ! -e "$oldGenPath/home-files" ]] ; then
  #       return
  #     fi
  #
  #     _i "Cleaning up orphan links from %s" "$HOME"
  #
  #     local newGenFiles oldGenFiles
  #     newGenFiles="$(readlink -e "$newGenPath/home-files")"
  #     oldGenFiles="$(readlink -e "$oldGenPath/home-files")"
  #
  #     # Apply the cleanup script on each leaf in the old
  #     # generation. The find command below will print the
  #     # relative path of the entry.
  #     find "$oldGenFiles" '(' -type f -or -type l ')' -printf '%P\0' \
  #       | xargs -0 bash /nix/store/s9p3c8fwpjnzdkyky4qbdfg339yqrb9a-cleanup "$newGenFiles"
  #   }
  #
  #   cleanOldGen
  #
  #   if [[ ! -v oldGenPath || "$oldGenPath" != "$newGenPath" ]] ; then
  #     _i "Creating profile generation %s" $newGenNum
  #     if [[ -e "$genProfilePath"/manifest.json ]] ; then
  #       # Remove all packages from "$genProfilePath"
  #       # `nix profile remove '.*' --profile "$genProfilePath"` was not working, so here is a workaround:
  #       nix profile list --profile "$genProfilePath" \
  #         | cut -d ' ' -f 4 \
  #         | xargs -rt $DRY_RUN_CMD nix profile remove $VERBOSE_ARG --profile "$genProfilePath"
  #       run nix profile install $VERBOSE_ARG --profile "$genProfilePath" "$newGenPath"
  #     else
  #       run nix-env $VERBOSE_ARG --profile "$genProfilePath" --set "$newGenPath"
  #     fi
  #
  #     run --quiet nix-store --realise "$newGenPath" --add-root "$newGenGcPath" --indirect
  #     if [[ -e "$legacyGenGcPath" ]]; then
  #       run rm $VERBOSE_ARG "$legacyGenGcPath"
  #     fi
  #   else
  #     _i "No change so reusing latest profile generation %s" "$oldGenNum"
  #   fi
  #
  #   linkNewGen
  # '');
    home.activation.linkGeneration = lib.mkForce (lib.hm.dag.entryAfter ["writeBoundary"] (
      let
        link = pkgs.writers.writeDash "link" ''
          export TEXTDOMAIN=hm-modules
          export TEXTDOMAINDIR=/nix/store/y9h1j5d6shkqd47clmcnd75kwwadgw4s-hm-modules-messages
          . /nix/store/zhrjg6wxrxmdlpn6iapzpp2z2vylpvw5-home-manager.sh

          newGenFiles="$1"
          shift
          for sourcePath in "$@" ; do
            relativePath="''${sourcePath#$newGenFiles/}"
            targetPath="$HOME/$relativePath"
            if [ -e "$targetPath" ] && [ ! -L "$targetPath" ] && [ -n "$HOME_MANAGER_BACKUP_EXT" ] ; then
              # The target exists, back it up
              backup="$targetPath.$HOME_MANAGER_BACKUP_EXT"
              run mv $VERBOSE_ARG "$targetPath" "$backup" || errorEcho "Moving '$targetPath' failed!"
            fi

            if [ -e "$targetPath" ] && [ ! -L "$targetPath" ] && cmp -s "$sourcePath" "$targetPath" ; then
              # The target exists but is identical – don't do anything.
              verboseEcho "Skipping '$targetPath' as it is identical to '$sourcePath'"
            else
              # Place that symlink, --force
              # This can still fail if the target is a directory, in which case we bail out.
              run mkdir -p $VERBOSE_ARG "$(dirname "$targetPath")"
              run ln -Tsf $VERBOSE_ARG "$sourcePath" "$targetPath" || exit 1
            fi
          done
        '';

        cleanup = pkgs.writeShellScript "cleanup" ''
          ${config.lib.bash.initHomeManagerLib}

          # A symbolic link whose target path matches this pattern will be
          # considered part of a Home Manager generation.
          homeFilePattern="$(readlink -e ${lib.escapeShellArg builtins.storeDir})/*-home-manager-files/*"

          newGenFiles="$1"
          shift 1
          for relativePath in "$@" ; do
            targetPath="$HOME/$relativePath"
            if [[ -e "$newGenFiles/$relativePath" ]] ; then
              verboseEcho "Checking $targetPath: exists"
            elif [[ ! "$(readlink "$targetPath")" == $homeFilePattern ]] ; then
              warnEcho "Path '$targetPath' does not link into a Home Manager generation. Skipping delete."
            else
              verboseEcho "Checking $targetPath: gone (deleting)"
              run rm $VERBOSE_ARG "$targetPath"

              # Recursively delete empty parent directories.
              targetDir="$(dirname "$relativePath")"
              if [[ "$targetDir" != "." ]] ; then
                pushd "$HOME" > /dev/null

                # Call rmdir with a relative path excluding $HOME.
                # Otherwise, it might try to delete $HOME and exit
                # with a permission error.
                run rmdir $VERBOSE_ARG \
                    -p --ignore-fail-on-non-empty \
                    "$targetDir"

                popd > /dev/null
              fi
            fi
          done
        '';
      in
        ''
          function linkNewGen() {
            _i "Creating home file links in %s" "$HOME"

            local newGenFiles
            newGenFiles="$(readlink -e "$newGenPath/home-files")"
            find "$newGenFiles" \( -type f -or -type l \) \
              -exec bash ${link} "$newGenFiles" {} +
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
              | xargs -0 bash ${cleanup} "$newGenFiles"
          }

          cleanOldGen

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
    ));
}
