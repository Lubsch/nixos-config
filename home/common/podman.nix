{ pkgs, ... }: {
  home.packages = with pkgs; [
    slirp4netns
    podman
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
    # Podman doesn't play well with bindfs
    { directory = ".local/share/containers"; method = "symlink"; }
  ];
}
