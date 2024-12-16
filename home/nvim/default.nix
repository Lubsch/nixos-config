{
  lib,
  inputs,
  pkgs,
  ...
}:
let
  # Mapping between "<name in lspconfig> = <package in pkgs>;"
  servers = with pkgs; {
    ts_ls = nodePackages.typescript-language-server;
    marksman = marksman;
    gopls = gopls;
    ocamllsp = ocamlPackages.ocaml-lsp;
    zls = zls;
    bashls = nodePackages.bash-language-server;
    jedi_language_server = python311Packages.jedi-language-server;
    rust_analyzer = rust-analyzer;
    hls = haskell-language-server;
    tinymist = tinymist; # typst
    nixd = nixd;
    clangd = clang-tools;
    jdtls = writeShellScriptBin "jdtls" "${jdt-language-server}/bin/jdt-language-server \"$@\"";
    # roc_ls = inputs.roc-lang.packages.${pkgs.system}.full;
  };
in
{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages =
      lib.attrValues servers
      ++ (with pkgs; [
        fd
        ripgrep
      ]);

    extraLuaConfig = # lua
      ''
        ${lib.readFile ./init.lua}
        -- install all grammars without slowing down startup
        vim.opt.runtimepath:append("${
          pkgs.symlinkJoin {
            name = "nvim-treesitter-grammars";
            paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
          }
        }")
        -- Enable lsp for all the languages
        ${lib.concatLines (lib.mapAttrsToList (n: _: "require'lspconfig'.${n}.setup{}") servers)}
      '';

    plugins = with pkgs.vimPlugins; [
      oil-nvim # file explorer
      nvim-surround
      neogit # git integration
      vim-better-whitespace # show trailing spaces
      diffview-nvim
      nvim-web-devicons # dependency of diffview
      comment-nvim
      nvim-autopairs
      nvim-lspconfig
      nvim-cmp # completion
      cmp-nvim-lsp
      cmp-path
      gruvbox-nvim # color scheme
      telescope-nvim # fuzzy search
      nvim-dap # debugger
      nvim-treesitter # highlighting
    ];
  };

  # persist log, shada, swap and undo (could require manual cleanup)
  persist.directories = [
    ".local/state/nvim"
  ];
}
