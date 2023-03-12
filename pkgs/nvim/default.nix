{ wrapNeovim, neovim-unwrapped, symlinkJoin, vimPlugins, rnix-lsp, clang }:
wrapNeovim neovim-unwrapped {
  configure = {
    customRC = ''
      lua << EOF
      -- install all treesitter grammars without slowing down startup
      vim.opt.runtimepath:append("${symlinkJoin {
        name = "treesitter-grammars";
        paths = vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
      } }")
      ${builtins.readFile ./init.lua}
      local lspconfig = require('lspconfig')
      lspconfig.rnix.setup{ cmd = { "${rnix-lsp}/bin/rnix-lsp" }, on_attach = an_attach }
      lspconfig.clangd.setup{ cmd = { "${clang}/bin/clangd" }, on_attach = on_attach }
      EOF
      ${builtins.readFile ./init.vim}
    '';
    packages.myVimPackage = {
      inherit (import ./plugins.nix vimPlugins) start opt;
    };
  };
}
