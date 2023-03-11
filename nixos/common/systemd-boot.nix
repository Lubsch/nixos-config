{
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
    };

    # The installation of the bootloader can touch efi vars
    efi.canTouchEfiVariables = true;
  };
}
