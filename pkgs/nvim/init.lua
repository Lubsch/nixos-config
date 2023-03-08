-- Improve startup time
require('impatient')

require("gruvbox").setup({ 
    italic = false,
    overrides = {
        LineNr = { fg = "#fabd2f" },
        LineNrAbove = { fg = "#7c6f64" },
        LineNrBelow = { fg = "#7c6f64" }
    }
})

local actions = require("telescope.actions")
require("telescope").setup{
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
                ["<C-j>"] = {
                  actions.move_selection_next, type = "action",
                  opts = { nowait = true, silent = true }
                },
                ["<C-k>"] = {
                  actions.move_selection_previous, type = "action",
                  opts = { nowait = true, silent = true }
                },
            }
        }
    }
}


-- Autopair
require 'nvim-autopairs':setup{}

-- treesitter
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
}

-- lsp
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { silent=true, buffer=bufnr }
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
  vim.keymap.set('n', '<space>=', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lspconfig = require('lspconfig')
lspconfig.rnix.setup{ on_attach = an_attach }
lspconfig.clangd.setup{ on_attach = on_attach }
