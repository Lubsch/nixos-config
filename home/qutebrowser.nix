{ config, lib, pkgs, ... }: {
  home.sessionVariables.BROWSER = lib.mkForce "qutebrowser";

  /*
  systemd.user.services.qutebrowser = {
    Unit = {
      Description = "Windowless qutebrowser on startup";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.qutebrowser}/bin/qutebrowser --nowindow";
      Restart = "on-failure";
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
  */

  programs.qutebrowser = {
    enable = true;

    extraConfig = ''
      config.unbind("<Ctrl-d>")
      config.unbind("<Ctrl-d>")
      config.unbind("d")
      config.unbind("u")
      config.bind("d", "scroll-page 0 0.5")
      config.bind("u", "scroll-page 0 -0.5")

      config.unbind("xo")
      config.unbind("xO")
      config.bind("x", "tab-close")
      config.bind("X", "undo")

      config.unbind("J")
      config.unbind("K")
      config.bind("J", "tab-prev")
      config.bind("K", "tab-next")

      config.set("fonts.default_family", "${config.fonts.regular.name}") 
      config.set("fonts.default_size", "11pt") 
    '';
  };

  home.persistence."/persist${config.home.homeDirectory}".directories = [ 
    ".local/share/qutebrowser"
  ];
}
