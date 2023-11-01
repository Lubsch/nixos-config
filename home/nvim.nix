{ lib, pkgs, ... }: {

  home.sessionVariables.EDITOR = "nvim";

  programs.neovim =
  let
    # Mapping between names (lspconfig = nixpkgs;)
    servers = with pkgs; {
      pylsp = python311Packages.python-lsp-server;
      rust_analyzer = rust-analyzer;
      hls = haskell-language-server;
      typst_lsp = typst-lsp;
      nixd = nixd;
      clangd = clang-tools;
      jdtls = writeShellScriptBin "jdtls" "${jdt-language-server}/bin/jdt-language-server $*";
    };
  in {
    enable = true;
    extraPackages = with pkgs; [ ghc fd ripgrep gdb ] ++ builtins.attrValues servers;
    extraConfig = /* vim */ ''
      lua vim.loader.enable()

      " Remap leader key
      nmap <Space> <leader>
      nmap <leader> <localleader>

      set mousescroll=ver:1

      " Conceal **emph** tags, for example
      set conceallevel=2

      " Use system clipboard
      set clipboard+=unnamedplus

      set undofile

      " Enable file type detection and do language-dependent indenting.
      filetype plugin indent on

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

      "Make split windows open at the bottom
      set splitbelow splitright

      "Indentation
      set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent
      autocmd FileType nix setlocal tabstop=2 softtabstop=2 shiftwidth=2

      "Disable automatic commenting on new line
      autocmd FileType * setlocal formatoptions-=r formatoptions-=o


      "Break lines between words
      set linebreak

      " Disable timeouts and delays
      set updatetime=0 notimeout

      "Fast saving
      nnoremap <leader>w :w<cr>
      " Go to wiki index
      nnoremap <leader>i :cd $HOME/documents/wiki<cr> :e $HOME/documents/wiki/index.md<cr>
      ":W doas saves file
      command! W silent execute 'w !doas tee % > /dev/null' <bar> edit!
    '';

    plugins = lib.mapAttrsToList (n: x: {
      type = x.type or "lua";
      plugin = x.plugin or pkgs.vimPlugins.${n};
      config = x.config or (if builtins.typeOf x == "string" then x else "");
    }) {
      vim-startuptime = /* lua */ '''';
      typst-vim = /* lua */ '''';
      comment-nvim = /* lua */ ''
        require'Comment'.setup{}
      '';
      nvim-autopairs = /* lua */ ''
        require'nvim-autopairs'.setup{}
      '';

      nvim-dap-ui = /* lua */ ''
        local dapui = require'dapui'
        dapui.setup{}
        local opts = { silent=true, noremap = true }
        vim.keymap.set('n', '<leader>u', dapui.toggle, opts)
      '';
      nvim-dap-rr = {
        plugin = pkgs.callPackage ../pkgs/nvim-dap-rr.nix {};
        config = /* lua */ ''
          local rr_dap = require("nvim-dap-rr")
          rr_dap.setup{ mappings = {} }

          local opts = { nowait = true, noremap = true, silent = true, }
          vim.keymap.set('n', 'ü', rr_dap.continue, opts)
          vim.keymap.set('n', 'ä', rr_dap.step_over, opts)
          vim.keymap.set('n', 'Ä', rr_dap.step_into, opts)
          vim.keymap.set('n', '<c-ä>', rr_dap.step_out, opts)
          vim.keymap.set('n', 'Ü', rr_dap.reverse_continue, opts)
          vim.keymap.set('n', 'ö', rr_dap.reverse_step_over, opts)
          vim.keymap.set('n', 'Ö', rr_dap.reverse_step_into, opts)
          vim.keymap.set('n', '<c-ö>', rr_dap.reverse_step_out, opts)

          local dap = require'dap'
          dap.adapters.cppdbg = {
            id = 'cppdbg',
            type = 'executable',
            command = '${pkgs.callPackage ../pkgs/mi-engine {}}/bin/OpenDebugAD7'
          }

          dap.configurations.c = { rr_dap.get_config() }
          dap.configurations.cpp = { rr_dap.get_config() }
          dap.configurations.rust = { rr_dap.get_rust_config() }
        '';
      };
      nvim-dap = /* lua */ ''
        local dap = require'dap'
        local opts = { nowait = true, noremap = true, silent = true, }
        vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, opts)
        vim.keymap.set({'n', 'v'}, '<Leader>h', require('dap.ui.widgets').hover, opts)
        vim.keymap.set('n', '<Leader>df', function()
          local widgets = require('dap.ui.widgets')
          widgets.centered_float(widgets.frames)
        end)
        vim.keymap.set('n', '<Leader>ds', function()
          local widgets = require('dap.ui.widgets')
          widgets.centered_float(widgets.scopes)
        end)

        -- dap.adapters.lldb = {
        --   type = 'executable',
        --   command = '${pkgs.lldb}/bin/lldb-vscode',
        --   name = 'lldb',
        -- }
        -- dap.configurations.c = {
        --     {
        --         name = 'Launch lldb',
        --         type = 'lldb',
        --         request = 'launch',
        --         program = function()
        --             return vim.fn.input(
        --                 'Path to executable: ',
        --                 vim.fn.getcwd() .. '/',
        --                 'file'
        --              )
        --         end,
        --         cwd = "''${workspaceFolder}",
        --         stopOnEntry = false,
        --         args = {},
        --         runInTerminal = false,
        --     },
        -- }
        -- dap.configurations.cpp = dap.configurations.c
        -- dap.configurations.rust = dap.configurations.c
        --local opts = { silent=true, noremap = true }
      '';

      nvim-lspconfig = /* lua */ ''
        -- Enable lsp for all the languages
        ${lib.concatLines (lib.mapAttrsToList (n: _: "require'lspconfig'.${n}.setup{}") servers)}

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<leader>=', function() vim.lsp.buf.format { async = true } end, bufopts)

        -- nvim included lsp: Borders around windows
        local _border = "single"
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
          vim.lsp.handlers.hover, {
            border = _border
          }
        )
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
          vim.lsp.handlers.signature_help, {
            border = _border
          }
        )
        vim.diagnostic.config{
          float={border=_border}
        }
      '';

      nvim-cmp = /* lua */ ''
        local cmp = require'cmp'
        cmp.setup{
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert{
                ['<Tab>'] = function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end,
                ['<S-Tab>'] = function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end,
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
      cmp-nvim-lsp = /* lua */ '''';
      cmp-path = /* lua */ '''';

      nvim-treesitter = {
        plugin = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [ p.c p.lua ]); # fix for lua and c
        config = /* lua */ ''
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
      };
      gruvbox-nvim = /* lua */ ''
        -- color scheme
        require'gruvbox'.setup{ 
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
        }
        vim.cmd("colorscheme gruvbox")
      '';
      telescope-nvim = /* lua */ ''
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
      local opts = { silent=true, noremap = true }
      vim.keymap.set('n', '<leader>f', ':Telescope find_files<cr>', opts)
      -- CONFLICT breakpoints vim.keymap.set('n', '<leader>b', ':Telescope buffers<cr>', opts) 
      vim.keymap.set('n', '<leader>g', ':Telescope live_grep<cr>', opts)
      vim.keymap.set('n', '<leader>t', ':Telescope<cr>', opts)
      '';
      telescope-fzf-native-nvim = '''';
    };
  };

  # persist log, shada, swap and undo (could require manual cleanup)
  persist.directories = [ 
    ".local/state/nvim" 
  ];
}
