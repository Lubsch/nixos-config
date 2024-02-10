{ pkgs, config, ... }: {
  boot.resumeDevice = config.fileSystems."/".device;

  # Sets resume_offset kernel parameter in the bootloader on every system activation
  # So you don't have to define it in the config on every swapfile regeneration
  boot.kernelParams = [ "resume_offset=0" ];
  system.activationScripts.set-resume-offset.text = ''
    # Get offset
    offset=$(${pkgs.btrfs-progs}/bin/btrfs inspect-internal map-swapfile -r /swap/swapfile)

    # Extract boot entry path of current generation "/boot/loader/nixos-generation-xxx.conf"
    entry_path=/boot/loader/entries/"$(grep 'default' /boot/loader/loader.conf | ${pkgs.gawk}/bin/awk '{print $2}')"

    # Set offset in entry file
    ${pkgs.gnused}/bin/sed -i "s/resume_offset=[0-9]*/resume_offset=$offset/" $entry_path

    # Write offset to currently running session
    echo $offset > /sys/power/resume_offset
  '';
}
