# TODO install grammars without rebuild
pkgs:
pkgs.wrapNeovim pkgs.neovim-unwrapped {
  configure = {
    customRC = ''
      lua << EOF
      -- install all treesitter grammars without slowing down startup
      vim.opt.runtimepath:append("${pkgs.symlinkJoin {
        name = "treesitter-grammars";
        paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
      } }")
      ${builtins.readFile ./init.lua}
      EOF
      ${builtins.readFile ./init.vim}
    '';
    packages.myVimPackage = with pkgs.vimPlugins; {
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
    };
  };
}
