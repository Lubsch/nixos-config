{ config, ... }: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "${config.fonts.mono.name}:size=10";
        dpi-aware = "yes";
      };
      /* colors = { */
      /*     background = colors.base00; */
      /*     foreground = colors.base05; */

      /*     regular0 = colors.base00; */
      /*     regular1 = colors.base01; */
      /*     regular2 = colors.base02; */
      /*     regular3 = colors.base03; */
      /*     regular4 = colors.base04; */
      /*     regular5 = colors.base05; */
      /*     regular6 = colors.base06; */
      /*     regular7 = colors.base07; */
      /*     bright0 = colors.base08; */
      /*     bright1 = colors.base09; */
      /*     bright2 = colors.base0A; */
      /*     bright3 = colors.base0B; */
      /*     bright4 = colors.base0C; */
      /*     bright5 = colors.base0D; */
      /*     bright6 = colors.base0E; */
      /*     bright7 = colors.base0F; */
      /* }; */
    };
  };
}
