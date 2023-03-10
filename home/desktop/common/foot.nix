{ colorscheme, fonts, ... }: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "${fonts.mono.name}:size=11";
        dpi-aware = "yes";
      };
    };
  };
}
