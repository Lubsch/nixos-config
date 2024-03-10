{ lib, pkgs, ... }:
let
  # Mapping between "<name in lspconfig> = <package in pkgs>;"
  servers = with pkgs; {
    ocamllsp = ocamlPackages.ocaml-lsp;
    zls = zls;
    bashls = nodePackages.bash-language-server;
    jedi_language_server = python311Packages.jedi-language-server;
    rust_analyzer = rust-analyzer;
    hls = haskell-language-server;
    typst_lsp = typst-lsp;
    nixd = nixd;
    clangd = clang-tools;
    jdtls = writeShellScriptBin "jdtls" "${jdt-language-server}/bin/jdt-language-server $*";
  };
in {

  home.sessionVariables.EDITOR = "nvim";

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [ fd ripgrep ] ++ lib.attrValues servers;
    extraLuaConfig = lib.readFile ./init.lua;
    plugins = with pkgs.vimPlugins; [
      vim-startuptime
      typst-vim
      comment-nvim
      nvim-autopairs
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      gruvbox-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      {
        type = "lua";
        plugin = nvim-dap;
        config = /*lua*/ ''
          -- Enable lsp for all the languages
          ${lib.concatLines (lib.mapAttrsToList (n: _: "require'lspconfig'.${n}.setup{}") servers)}
        '';
      }
      {
        type = "lua";
        # has weird errors for c, lua and vimdoc otherwise
        plugin = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [ p.c p.lua p.vimdoc ]);
        config = /*lua*/ ''
          require'nvim-treesitter.configs'.setup {
              highlight = {
                  enable = true,
              },
          }
          -- install all grammars without slowing down startup
          vim.opt.runtimepath:append("${pkgs.symlinkJoin {
            name = "nvim-treesitter-grammars";
            paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
          } }")
        '';
      }
    ];
  };

  # persist log, shada, swap and undo (could require manual cleanup)
  persist.directories = [ 
    ".local/state/nvim" 
  ];
}
