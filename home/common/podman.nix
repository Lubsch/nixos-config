{ pkgs, ... }:
{
  home.packages = with pkgs; [
    slirp4netns
    podman
    podman-compose
  ];

  xdg.configFile."containers/policy.json".text = ''
    {
        "default": [
            {
                "type": "insecureAcceptAnything"
            }
        ]
    }
  '';

  xdg.configFile."containers/registries.conf".text = ''
    [registries.search]
      registries = ['docker.io']
      [registries.block]
      registries = []
  '';

  persist.directories = [
    # ".local/share/containers"
    # Podman doesn't play well with bindfs
    {
      directory = ".local/share/containers";
      method = "symlink";
    }
  ];
}
