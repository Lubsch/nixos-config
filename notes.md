Replace or improve systemd-boot/systemd-boot.nix
    - written in rust because it's most acceptable
    - remove nix-env invocations
    - profiling
    - look into popos's systemd-boot rust library
    - modify module to call the program directly
        - shell script with extra bootloader commands only if they're specified
    - concurrency

Modify switch-to-generation
    - profiling
    - concurrency
    - find out what systemd is doing

profiling
    - cargo-flamegraph works well enough ig

re script
    - also rewrite it in rust(?)

home manager activation
    - parallelize start section of script
        - e.g. sanity checks, nix-build test etc.
        - I think we don't need threads, just spawn multiple commands
        - really understand dependency chains
    - replace linkGeneration and checkCollision completely
        - split up script to include writeBoundary
        - maybe store dirs and links to create / modify in extra file
        - consider just reading from $HOME again when doing linkGeneration
        - exactly emulate script behavior (except slowness)
            - symlink behavior(!)
            - symlink redirection is not noticeable


Investigate evaluating with tvix
