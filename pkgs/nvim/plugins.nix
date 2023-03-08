pkgs:
with pkgs.vimPlugins; {
  start = [
    nvim-treesitter
    nvim-lspconfig
    vim-commentary
    nvim-autopairs
    tex-conceal-vim
    gruvbox-nvim
    asyncrun-vim
    telescope-nvim
    telescope-fzf-native-nvim
    vim-startuptime
    impatient-nvim
    markdown-preview-nvim
  ];
  opt = [];
}
