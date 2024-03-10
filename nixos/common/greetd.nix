{ config, lib, pkgs, ... }: 
let
  users = builtins.attrNames config.home-manager.users;
  user = if builtins.length users == 1 then builtins.head users else null;
  command = config.home-manager.users.${user}.home.sessionVariables.WM or config.users.users.${user}.shell.pname;
in
{
  # Automatic login if there is only one user
  services.greetd = lib.mkIf (user != null) {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${command}";
        };
      initial_session = { inherit command user; };
    };
  };
}
