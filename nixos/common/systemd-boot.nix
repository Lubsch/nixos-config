{
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
    };

    # The installatin of the bootloader can touch efi vars
    efi.canTouchEfiVariabe = true;
  };
}
