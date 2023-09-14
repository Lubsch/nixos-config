{ pkgs, ... }: {

  services.printing = {
    enable = true;
    webInterface = false;
    drivers = [ pkgs.hplip ];
  };

  # Use hp-setup from hpclip,
  # inspect /var/lib/cups/printers.conf
  hardware.printers.ensurePrinters = [ {
    name = "Deskjet-3050A-J611";
    deviceUri = "hp:/net/Deskjet_3050A_J611_series?ip=192.168.178.78";
    model = "drv:///hp/hpcups.drv/hp-deskjet_3050a_j611_series.ppd";
    ppdOptions = {
      PageSize = "A4";
      ColorModel = "CMYGray";
    };
  } ];

}
