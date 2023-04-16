{ 
  console.useXkbConfig = true;
  services.xserver = {
    layout = "de";
    xkbOptions = "caps:escape,altwin:swap_lalt_lwin";
  };
}
