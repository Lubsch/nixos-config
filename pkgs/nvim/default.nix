pkgs:
pkgs.symlinkJoin {
  name = "nvim";
  paths = [
    (pkgs.wrapNeovim pkgs.neovim-unwrapped {
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
        packages.myVimPackage = {
          inherit (import ./plugins.nix pkgs.vimPlugins) start opt;
        };
      };
    })
    # Install clangd via project-specific libglang
    pkgs.rnix-lsp
  ];
}
