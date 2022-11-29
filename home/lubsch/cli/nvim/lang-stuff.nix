{ pkgs, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = mkdnflow.nvim;
      config = ''
        lua >> EOF
        -- ** DEFAULT SETTINGS; TO USE THESE, PASS NO ARGUMENTS TO THE SETUP FUNCTION **
        require('mkdnflow').setup({
            modules = {
                folds = false,
            },
            perspective = {
                priority = 'root',
                root_tell = 'index.md',
            },    
            wrap = false,
            silent = true,
            links = {
                conceal = true,
            },
            to_do = {
                symbols = {' ', 'X'},
            },
            mappings = {
              MkdnTableNewRowBelow = {{'n', 'i'}, '<leader>ir'},
              MkdnTableNewRowAbove = {{'n', 'i'}, '<leader>iR'},
              MkdnTableNewColAfter = {{'n', 'i'}, '<leader>ic'},
              MkdnTableNewColBefore = {{'n', 'i'}, '<leader>iC'},
            }
        })
        EOF
      '';
    }
    {
      plugin = tex-conceal.vim;
      config = ''
        set conceallevel=2
        let g:tex_conceal="abdmg"
      '';
    }
    {
      plugin = nvim-treesitter.withPlugins (p: attrValues (removeAttrs p [ "tree-sitter-nix" ]));
      config = "lua require'nvim-treesitter.configs'.setup{highlight.enable=true,indent.enable=true;}";
    }
    {
      plugin = nvim-lspconfig;
      config = ''
        lua >> EOF
        local opts = { noremap=true, silent=true }
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        -- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

        -- Use an on_attach function to only map the following keys
        -- after the language server attaches to the current buffer
        local on_attach = function(client, bufnr)
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- Mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local bufopts = { noremap=true, silent=true, buffer=bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
        end

        require'lspconfig'.rnix.setup{} -- nix
        EOF
      '';
    }
  ];
}
