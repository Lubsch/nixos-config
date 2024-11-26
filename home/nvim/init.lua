vim.loader.enable()
vim.cmd([[
    " Remap leader key
    nmap <Space> <leader>
    nmap <leader> <localleader>

    "Singe mouse scroll
    set mousescroll=ver:1

    " Conceal **emph** tags, for example
    set conceallevel=2

    " Use system clipboard
    set clipboard+=unnamedplus

    set undofile

    " Search
    set ignorecase smartcase hlsearch incsearch magic
    "Clear search highlighting with esc
    nnoremap <silent> <esc> :noh<CR><esc>

    "Relative line numbers
    set number relativenumber
    "Assume 10 or more lines, expand only at 100, 1000...
    set numberwidth=3
    "Always show debug sign column
    set signcolumn=yes
    "Color signcolumn correctly
    hi SignColumn guibg=bg

    "Make split windows open at the bottom
    set splitbelow splitright

    " Enable file type detection and do language-dependent indenting.
    filetype plugin indent on

    "Indentation
    set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
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
    ":W sudo saves file
    command! W silent execute "w !sudo tee % > /dev/null" <bar> edit!
    "Use quickfix list comfortably
    nnoremap <tab> :cnext<cr>
    nnoremap <s-tab> :cprev<cr>
    nnoremap <leader><esc> :cclose<cr>
]])

require'oil'.setup{}
require'Comment'.setup{}
require'neogit'.setup{}

require'nvim-surround'.setup{
    keymaps = {
        normal = "s",
        normal_cur = "ss",
        visual = "s",
        visual_cur = "ss",
    }
}

npairs = require 'nvim-autopairs'
Rule = require 'nvim-autopairs.rule'
cond = require 'nvim-autopairs.conds'
npairs.setup {
    enable_bracket_in_quote = false
}

npairs.add_rules{
    Rule("$", "$", {"tex", "latex", "typst"})
}

local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
npairs.add_rules {
  -- Rule for a pair with left-side ' ' and right side ' '
  Rule(' ', ' ')
    -- Pair will only occur if the conditional function returns true
    :with_pair(function(opts)
      -- We are checking if we are inserting a space in (), [], or {}
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({
        brackets[1][1] .. brackets[1][2],
        brackets[2][1] .. brackets[2][2],
        brackets[3][1] .. brackets[3][2]
      }, pair)
    end)
    :with_move(cond.none())
    :with_cr(cond.none())
    -- We only want to delete the pair of spaces when the cursor is as such: ( | )
    :with_del(function(opts)
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local context = opts.line:sub(col - 1, col + 2)
      return vim.tbl_contains({
        brackets[1][1] .. '  ' .. brackets[1][2],
        brackets[2][1] .. '  ' .. brackets[2][2],
        brackets[3][1] .. '  ' .. brackets[3][2]
      }, context)
    end)
}
-- For each pair of brackets we will add another rule
for _, bracket in pairs(brackets) do
  npairs.add_rules {
    -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
    Rule(bracket[1] .. ' ', ' ' .. bracket[2])
      :with_pair(cond.none())
      :with_move(function(opts) return opts.char == bracket[2] end)
      :with_del(cond.none())
      :use_key(bracket[2])
      -- Removes the trailing whitespace that can occur without this
      :replace_map_cr(function(_) return '<C-c>2xi<CR><C-c>O' end)
  }
end

require'nvim-treesitter.configs'.setup {
  highlight = {
      enable = true,
  },
}

local dap = require'dap'
dap.adapters.rr = {
  type = 'executable',
  command = 'rr',
  args = { 'replay', '-i', 'dap' },
}
dap.configurations.c = {
  {
    name = 'Launch',
    type = 'rr',
    request = 'launch',
  },
}
local opts = { nowait = true, noremap = true, silent = true, }
vim.keymap.set('n', 'ü', dap.continue, opts)
vim.keymap.set('n', 'ä', dap.step_over, opts)
vim.keymap.set('n', 'Ä', dap.step_into, opts)
vim.keymap.set('n', '<c-ä>', dap.step_out, opts)
vim.keymap.set('n', 'Ü', function() dap.repl.execute("rc") end, opts)
vim.keymap.set('n', 'ö', function() dap.repl.execute("rs") end, opts)

vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, opts)
vim.keymap.set('n', '<Leader>B', dap.clear_breakpoints, opts)
vim.keymap.set({'n', 'v'}, '<Leader>h', require('dap.ui.widgets').preview, opts)

-- vim.keymap.set('n', '<Leader>df', function()
--   local widgets = require('dap.ui.widgets')
--   widgets.centered_float(widgets.frames)
-- end)
-- vim.keymap.set('n', '<Leader>ds', function()
--   local widgets = require('dap.ui.widgets')
--   widgets.centered_float(widgets.scopes)
-- end)

-- lsp mappings.
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



-- colorscheme
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
