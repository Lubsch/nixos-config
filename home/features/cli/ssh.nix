{ outputs
, lib
, ...
}:
let
  hostnames = builtins.attrNames outputs.nixosConfigurations;
in
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      net = {
        host = builtins.concatStringsSep " " hostnames;
        forwaredAgent = true;
        remoteForwareds = [{
            bind.address = "/run/user/1000/gnupg/S.gpg-agent";
            host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
          }];
      };
    };
  };

  home.persistence = {
    "/persist/home/lubsch".directories = [ ".ssh" ];
  };
}
