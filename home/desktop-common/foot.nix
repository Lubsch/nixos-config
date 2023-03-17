{ config, ... }: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "${config.fonts.mono.name}:size=10";
        dpi-aware = "yes";
      };
      colors = with config.colors; {
        inherit background foreground alpha;

        regular0 = base00;
        regular1 = base01;
        regular2 = base02;
        regular3 = base03;
        regular4 = base04;
        regular5 = base05;
        regular6 = base06;
        regular7 = base07;
        bright0 = base08;
        bright1 = base09;
        bright2 = base10;
        bright3 = base11;
        bright4 = base12;
        bright5 = base13;
        bright6 = base14;
        bright7 = base15;
      };
    };
  };
}
