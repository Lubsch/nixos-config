# TODO install grammars without rebuild
pkgs:
with pkgs; 
wrapNeovim neovim-unwrapped {
  configure = {
    customRC = ''
      lua << EOF
      -- DAP
      local dap = require('dap')
      dap.adapters.lldb = {
        type = 'executable',
        command = '${lldb}/bin/lldb-vscode',
        name = 'lldb'
      }
      -- install all treesitter grammars without slowing down startup
      vim.opt.runtimepath:append("${symlinkJoin {
        name = "treesitter-grammars";
        paths = vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
      } }")
      ${builtins.readFile ./init.lua}
      EOF
      ${builtins.readFile ./init.vim}
    '';
    packages.myVimPackage = with vimPlugins; {
      start = [
        nvim-dap
        nvim-cmp
        cmp-nvim-lsp
        cmp-path
        typst-vim
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
