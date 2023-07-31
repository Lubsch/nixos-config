# Server-packages (although not always co-installed) are defined here, too so there's fewer files to modify
{ pkgs, with-servers, ... }:
let 
  servers = with pkgs; [
    { package = typst-lsp; name = "typst_lsp"; }
    { package = nixd; }
    { package = clang-tools; name = "clangd"; binary = "clangd"; }
    { package = jdt-language-server; name = "jdtls"; binary = "jdt-language-server";
      opts = "{ cmd = { 'jdt-language-server', '-configuration', '$HOME/.cache/jdtls/config', '-data', '$HOME/.cache/jdtls/workspace' }, init_options = { workspace = '$HOME/.cache/jdtls/workspace' } }"; }
  ];

  setup-server = { package, name ? package.pname, binary ? package.pname, opts ? "{}" }: 
    "if vim.fn.executable'${binary}' == 1 then require'lspconfig'.${name}.setup${opts} end";

  mynvim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          conjure
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
in 
pkgs.symlinkJoin {
  name = "nvim";
  paths = [ mynvim ] ++ (if with-servers then map (s: s.package) servers else []);
}
