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
    typst_lsp = typst-lsp;
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
      oil-nvim
      nvim-surround
      neogit
      vim-better-whitespace
      diffview-nvim
      nvim-web-devicons
      comment-nvim
      nvim-autopairs
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      gruvbox-nvim
      telescope-nvim
      nvim-dap
      nvim-treesitter
      # (nvim-treesitter.withPlugins (p: [
      #   p.c
      #   p.lua
      #   p.vimdoc
      # ])) # has weird errors for c, lua and vimdoc otherwise
    ];
  };

  # persist log, shada, swap and undo (could require manual cleanup)
  persist.directories = [ ".local/state/nvim" ];
}
