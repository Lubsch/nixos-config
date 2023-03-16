{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  security.polkit.enable = true;
  programs.dconf.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  fonts.enableDefaultFonts = true;
}
