Replace or improve systemd-boot/systemd-boot.nix
    - written in rust because it's most acceptable
    - remove nix-env invocations
    - profiling
    - look into popos's systemd-boot rust library
    - modify module to call the program directly
        - shell script with extra bootloader commands only if they're specified
    - parallelization

Modify switch-to-generation
    - profiling
    - parallelization
    - find out what systemd is doing

profiling
    - cargo-flamegraph works well enough ig

re script
    - investigate other language than python
    - maybe use libgit

Investigate evaluating with tvix
