{ pkgs, ... }: {
  imports = [
    ./git.nix
    ./ssh.nix
    ./zsh.nix
    ./trash.nix
    ./exa.nix
  ];
  home.packages = with pkgs; [
    comma # run programs without installing
    ncdu # disk usage viewing

    tealdeer # tldr pages
    neofetch # system info
    ripgrep # better grep
    fd # better find
  ];
}
