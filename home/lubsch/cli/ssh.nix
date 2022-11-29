{ outputs
, hostname
, ...
}:
let
  inherit (builtins) attrNames concatStringsSep filter;
  notSelf = n: n != hostName;
  hostNames = filter notSelf (attrNames outputs.nixosConfigurations);
in
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      home = {
        host = concatSTringsSep " " hostnames;
        forwaredAgent = true;
        remoteForwareds = [
          {
            bind.address = "/run/user/1000/gnupg/S.gpg-agent";
            host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
          }
        ];
      };
    };
  };
}
