# TODO install grammars without rebuild
pkgs:
pkgs.wrapNeovim pkgs.neovim-unwrapped {
  configure = {
    customRC = ''
      lua << EOF
      ${builtins.readFile ./init.lua}
      local lspconfig = require('lspconfig')
      lspconfig.rnix.setup{ cmd = { "${pkgs.rnix-lsp}/bin/rnix-lsp" }, on_attach = an_attach }
      lspconfig.clangd.setup{ cmd = { "${pkgs.clang-tools}/bin/clangd" }, on_attach = on_attach }
      EOF
      ${builtins.readFile ./init.vim}
    '';
    packages.myVimPackage = {
      inherit (import ./plugins.nix pkgs.vimPlugins) start opt;
    };
  };
}
