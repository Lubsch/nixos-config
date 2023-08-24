# Server-packages (not always co-installed) defined here, too for code centralization
{ pkgs, lsp }:
let 

  servers = with pkgs; [
    { pkg = typst-lsp; name = "typst_lsp"; }
    { pkg = nixd; }
    # { pkg = clang-tools; name = "clangd"; cmd = "clangd"; }
    { pkg = ccls; opts = "{ init_options = { cache = { directory = '' } } }"; }
    { pkg = jdt-language-server; name = "jdtls"; opts = "{ cmd = { 'jdt-language-server', '-configuration', '$HOME/.cache/jdtls/config', '-data', '$HOME/.cache/jdtls/workspace' }, init_options = { workspace = '$HOME/.cache/jdtls/workspace' } }"; }
  ];

  setup-server = { pkg, name ? pkg.pname, cmd ? pkg.pname, opts ? "{}" }: ''
    if vim.fn.executable'${cmd}' == 1 then require'lspconfig'.${name}.setup${opts} end
  '';

in
pkgs.wrapNeovim pkgs.neovim-unwrapped {
  configure = {
    packages.myVimPackage = with pkgs.vimPlugins; {
      start = [
        nvim-dap
        nvim-dap-ui
        nvim-cmp
        cmp-nvim-lsp
        cmp-path
        typst-vim
        nvim-treesitter
        nvim-lspconfig
        vim-commentary
        nvim-autopairs
        gruvbox-nvim
        telescope-nvim
        telescope-fzf-native-nvim
        vim-startuptime
      ];
    };
    customRC = ''
      lua << EOF
      ${builtins.concatStringsSep "\n" (map setup-server servers)}
      ${builtins.readFile ./init.lua}
      -- install all treesitter grammars without slowing down startup
      vim.opt.runtimepath:append("${pkgs.symlinkJoin {
        name = "treesitter-grammars";
        paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
      } }")
      EOF
      ${builtins.readFile ./init.vim}
    '';
  };
  extraMakeWrapperArgs = "--suffix PATH : ${with pkgs; lib.makeBinPath (
    [ fd ripgrep ] ++ (if lsp then map (s: s.pkg) servers else [])
  )}";
}
