{ pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  xdg.portal = {
    enable = true;
    config.common.default = [ "gtk" ];
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      # pkgs.xdg-desktop-portal-hyprland
    ];
  };

  security.polkit.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = [ pkgs.dconf-editor ];
  programs.dconf.enable = true;

  fonts.enableDefaultPackages = true;
}
