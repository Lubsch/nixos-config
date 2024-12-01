# NOTE re-add hplip when printer needs to be rediscovered or it's not working
{ pkgs, ... }:
{

  # cups webinterface:
  # http://localhost:631/printers
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };

  # Use hp-setup from hpclip,
  # inspect /var/lib/cups/printers.conf
  hardware.printers.ensurePrinters = [
    {
      name = "Deskjet-3050A-J611";
      deviceUri = "hp:/net/Deskjet_3050A_J611_series?ip=192.168.178.78";
      model = "drv:///hp/hpcups.drv/hp-deskjet_3050a_j611_series.ppd";
      ppdOptions = {
        PageSize = "A4";
        ColorModel = "CMYGray";
      };
    }
  ];

  # Scanners
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplip ];
  };
}
