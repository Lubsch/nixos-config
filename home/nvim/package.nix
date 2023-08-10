# Server-packages (although not always co-installed) are defined here, too so there's fewer files to modify
pkgs:
let 
  servers = with pkgs; [
    { pkg = typst-lsp; name = "typst_lsp"; }
    { pkg = nixd; }
    { pkg = clang-tools; name = "clangd"; bin = "clangd"; }
    { pkg = jdt-language-server; name = "jdtls"; opts = "{ cmd = { 'jdt-language-server', '-configuration', '$HOME/.cache/jdtls/config', '-data', '$HOME/.cache/jdtls/workspace' }, init_options = { workspace = '$HOME/.cache/jdtls/workspace' } }"; }
  ];
  setup-server = { pkg, name ? pkg.pname, bin ? pkg.pname, opts ? "{}" }: 
    "if vim.fn.executable'${bin}' == 1 then require'lspconfig'.${name}.setup${opts} end";

  nvim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
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
          markdown-preview-nvim
        ];
      };
      customRC = ''
        lua << EOF
        ${builtins.concatStringsSep "\n" (map setup-server servers)}
        ${builtins.readFile ./init.lua}
        dap.adapters.lldb = {
          type = 'executable',
          command = '${pkgs.lldb}/bin/lldb-vscode',
          name = 'lldb'
        }
        -- install all treesitter grammars without slowing down startup
        vim.opt.runtimepath:append("${pkgs.symlinkJoin {
          name = "treesitter-grammars";
          paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
        } }")
        EOF
        ${builtins.readFile ./init.vim}
      '';
    };
  }; 
  
  

in {
  inherit nvim;
  nvim-lsp = pkgs.symlinkJoin {
    name = "nvim";
    paths = [ nvim ] ++ map (s: s.pkg) servers;
  };
}
