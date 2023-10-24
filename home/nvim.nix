{ lib, pkgs, ... }: {

  home.sessionVariables.EDITOR = "nvim";

  programs.neovim =
  let
    servers = with pkgs; {
      hls = haskell-language-server;
      typst_lsp = typst-lsp;
      nixd = nixd;
      clangd = clang-tools;
      jdtls = pkgs.writeShellScriptBin "jdtls" "${jdt-language-server}/bin/jdt-language-server $*";
    };
  in {
    enable = true;

    extraConfig = ''
      lua vim.loader.enable()

      " Remap leader key
      nmap <Space> <leader>
      nmap <leader> <localleader>

      set mousescroll=ver:1

      " Conceal **emph** tags, for example
      set conceallevel=2

      " Use system clipboard
      set clipboard+=unnamedplus

      " Enable file type detection and do language-dependent indenting.
      filetype plugin indent on

      set undofile

      " Search
      set ignorecase hlsearch incsearch magic
      "Clear search highlighting with esc
      nnoremap <silent> <esc> :noh<CR><esc>

      "Relative line numbers
      set number relativenumber numberwidth=1
      "Always show debug sign column
      set signcolumn=yes
      "Color signcolumn correctly
      hi SignColumn guibg=bg

      "Indentation
      set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent
      autocmd FileType nix setlocal tabstop=2 softtabstop=2 shiftwidth=2

      "Break lines between words
      set linebreak

      "4000ms by default, would lead to delays
      set updatetime=0
      " Disable escape timeout
      set notimeout

      "SHORTCUTS
      "Toggle spell checking
      nnoremap <leader>od :set spell spelllang=de<cr>
      nnoremap <leader>oe :set spell spelllang=en<cr>
      nnoremap <leader>oo :setlocal spell!<cr>
      "Fast saving
      nnoremap <leader>w :w<cr>
      " Go to wiki index
      nnoremap <leader>i :cd $HOME/documents/wiki<cr> :e $HOME/documents/wiki/index.md<cr>
      ":W doas saves file
      command! W silent execute 'w !doas tee % > /dev/null' <bar> edit!
      " Telescope binds
      nnoremap <silent> <leader>f :Telescope find_files<cr>
      nnoremap <silent> <leader>b :Telescope buffers<cr>
      nnoremap <silent> <leader>g :Telescope live_grep<cr>

      "Disable automatic commenting on new line
      autocmd FileType * setlocal formatoptions-=r formatoptions-=o

      "Make split windows open at the bottom
      set splitbelow splitright
    '';

    plugins = lib.mapAttrsToList (n: x: {
      type = x.type or "lua";
      plugin = x.plugin or pkgs.vimPlugins.${n};
      config = x.config or (if builtins.typeOf x == "string" then x else "");
    })
    {
        vim-startuptime = '''';
        typst-vim = '''';

        # DAP
        nvim-dap-ui = '''';
        nvim-dap = ''
          local dap = require'dap'
          dap.configurations.cpp = {
              {
                  name = 'Launch',
                  type = 'lldb',
                  request = 'launch',
                  program = function()
                      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                  end,
                  -- cwd = "''${workspaceFolder}",
                  stopOnEntry = false,
                  args = {},

                  -- 💀
                  -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
                  --
                  --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
                  --
                  -- Otherwise you might get the following error:
                  --
                  --    Error on launch: Failed to attach to the target process
                  --
                  -- But you should be aware of the implications:
                  -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
                  -- runInTerminal = false,
              },
          }

          -- If you want to use this for Rust and C, add something like this:
          dap.configurations.c = dap.configurations.cpp
          dap.configurations.rust = dap.configurations.cpp
        '';

        nvim-lspconfig = ''
          -- Enable language servers of different languages
          ${lib.concatLines (lib.mapAttrsToList (n: _: "require'lspconfig'.${n}.setup{}") servers)}

          -- See `:help vim.diagnostic.*` for documentation on any of the below functions
          local opts = { noremap=true, silent=true }
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

          -- Mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local bufopts = { silent=true, buffer=bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          -- vim.keymap.set('n', '<space>wl', function()
          --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          -- end, bufopts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<space>=', function() vim.lsp.buf.format { async = true } end, bufopts)
        '';

        nvim-cmp = ''
          local cmp = require'cmp'
          cmp.setup{
              window = {
                  completion = cmp.config.window.bordered(),
                  documentation = cmp.config.window.bordered(),
              },
              mapping = cmp.mapping.preset.insert{
                  ['<Tab>'] = function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end,
                  ['<S-Tab>'] = function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end,
                  ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-d>'] = cmp.mapping.scroll_docs(4),
                  ['<C-Space>'] = cmp.mapping.complete(),
                  ['<C-e>'] = cmp.mapping.abort(),
                  -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                  ['<CR>'] = cmp.mapping.confirm({ select = true }),
              },
              sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
              },
          }
        '';
        cmp-nvim-lsp = '' '';
        cmp-path = '' '';

        nvim-treesitter = {
          plugin = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [ p.c p.lua ]); # fixes not working for lua and c
          config = ''
            require'nvim-treesitter.configs'.setup {
                highlight = {
                    enable = true,
                },
            }
            -- install all grammars without slowing down startup
            vim.opt.runtimepath:append("${pkgs.symlinkJoin {
              name = "nvim-ts-grammars";
              paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
            } }")
          '';
        };
        comment-nvim = ''
          require'Comment'.setup{}
        '';
        nvim-autopairs = ''
          require'nvim-autopairs'.setup{}
        '';
        gruvbox-nvim = ''
          -- color scheme
          require'gruvbox'.setup({ 
              transparent_mode = true,
              italic = {
                  strings = false,
                  operators = false,
              },
              overrides = {
                  LineNr = { fg = "#fabd2f" },
                  LineNrAbove = { fg = "#7c6f64" },
                  LineNrBelow = { fg = "#7c6f64" }
              }
          })
          vim.cmd("colorscheme gruvbox")
        '';

        telescope-nvim = ''
          local actions = require'telescope.actions'
          require'telescope'.setup{
              defaults = require'telescope.themes'.get_ivy {
                  mappings = {
                      i = {
                          ["<esc>"] = actions.close,
                          ["<Tab>"] = {
                              actions.move_selection_next, type = "action",
                              opts = { nowait = true, silent = true }
                          },
                          ["<S-Tab>"] = {
                              actions.move_selection_previous, type = "action",
                              opts = { nowait = true, silent = true }
                          },
                      }
                  }
              }
          }
        '';
        telescope-fzf-native-nvim = '''';
    };

    extraPackages = with pkgs; [ fd ripgrep ] ++ builtins.attrValues servers;
  };

  # Persist log, shada, swap and undo (could require manual cleanup)
  persist.directories = [ 
    ".local/state/nvim" 
  ];
}
