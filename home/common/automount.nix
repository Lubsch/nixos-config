{ nixosConfig ? {}, ... }: {
  services.udiskie = {
    enable = nixosConfig.services.udisks2.enable or false;
    tray = "never";
  };
}
