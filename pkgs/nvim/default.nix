# Server-packages (not always co-installed) defined here, too for code centralization
{ pkgs, lsp }:
let 
  inherit (pkgs) lib;

  servers = with pkgs; {
    typst_lsp = typst-lsp;
    nixd = nixd;
    clangd = clang-tools;
    jdtls = (pkgs.writeShellScriptBin "jdtls" ''
      ${jdt-language-server}/bin/jdt-language-server $*
    '');
  };

in
pkgs.neovim.override {
  configure = {
    packages.myVimPackage = with pkgs.vimPlugins; {
      start = [
        nvim-dap
        nvim-dap-ui
        nvim-cmp
        cmp-nvim-lsp
        cmp-path
        typst-vim
        (nvim-treesitter.withPlugins (p: [ p.c p.lua ])) # fix lua and c not working
        nvim-lspconfig
        comment-nvim
        nvim-autopairs
        gruvbox-nvim
        telescope-nvim
        telescope-fzf-native-nvim
        vim-startuptime
      ];
    };
    customRC = ''
      lua << EOF
      -- Install language servers
      ${if lsp then lib.concatLines (lib.mapAttrsToList (n: _: "require'lspconfig'.${n}.setup{}") servers) else ""}
      -- install all treesitter grammars without slowing down startup
      vim.opt.runtimepath:append("${pkgs.symlinkJoin {
        name = "ts-nvim-grammars";
        paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
      } }")
      ${builtins.readFile ./init.lua}
      EOF
      ${builtins.readFile ./init.vim}
    '';
  };
  extraMakeWrapperArgs = "--suffix PATH : ${with pkgs; lib.makeBinPath (
    [ fd ripgrep ] ++ (if lsp then builtins.attrValues servers else [])
  )}";
}
