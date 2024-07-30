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
    set number relativenumber numberwidth=1
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
    nnoremap <leader>n :cnext<cr>
    nnoremap <leader>p :cprev<cr>
    nnoremap <leader><esc> :cclose<cr>
]])

require'lspconfig'.agda_ls.setup{}
require'lspconfig'.aiken.setup{}
require'lspconfig'.als.setup{}
require'lspconfig'.anakin_language_server.setup{}
require'lspconfig'.angularls.setup{}
require'lspconfig'.ansiblels.setup{}
require'lspconfig'.antlersls.setup{}
require'lspconfig'.apex_ls.setup{}
require'lspconfig'.arduino_language_server.setup{}
require'lspconfig'.asm_lsp.setup{}
require'lspconfig'.ast_grep.setup{}
require'lspconfig'.astro.setup{}
require'lspconfig'.autotools_ls.setup{}
require'lspconfig'.awk_ls.setup{}
require'lspconfig'.azure_pipelines_ls.setup{}
require'lspconfig'.bacon_ls.setup{}
require'lspconfig'.basedpyright.setup{}
require'lspconfig'.bashls.setup{}
require'lspconfig'.beancount.setup{}
require'lspconfig'.bicep.setup{}
require'lspconfig'.biome.setup{}
require'lspconfig'.bitbake_language_server.setup{}
require'lspconfig'.bitbake_ls.setup{}
require'lspconfig'.blueprint_ls.setup{}
require'lspconfig'.bqnlsp.setup{}
require'lspconfig'.bright_script.setup{}
require'lspconfig'.bsl_ls.setup{}
require'lspconfig'.buck2.setup{}
require'lspconfig'.buddy_ls.setup{}
require'lspconfig'.bufls.setup{}
require'lspconfig'.bzl.setup{}
require'lspconfig'.cadence.setup{}
require'lspconfig'.cairo_ls.setup{}
require'lspconfig'.ccls.setup{}
require'lspconfig'.cds_lsp.setup{}
require'lspconfig'.circom-lsp.setup{}
require'lspconfig'.clangd.setup{}
require'lspconfig'.clarity_lsp.setup{}
require'lspconfig'.clojure_lsp.setup{}
require'lspconfig'.cmake.setup{}
require'lspconfig'.cobol_ls.setup{}
require'lspconfig'.codeqlls.setup{}
require'lspconfig'.coffeesense.setup{}
require'lspconfig'.contextive.setup{}
require'lspconfig'.coq_lsp.setup{}
require'lspconfig'.crystalline.setup{}
require'lspconfig'.csharp_ls.setup{}
require'lspconfig'.css_variables.setup{}
require'lspconfig'.cssls.setup{}
require'lspconfig'.cssmodules_ls.setup{}
require'lspconfig'.cucumber_language_server.setup{}
require'lspconfig'.custom_elements_ls.setup{}
require'lspconfig'.cypher_ls.setup{}
require'lspconfig'.dafny.setup{}
require'lspconfig'.dagger.setup{}
require'lspconfig'.dartls.setup{}
require'lspconfig'.dcmls.setup{}
require'lspconfig'.debputy.setup{}
require'lspconfig'.delphi_ls.setup{}
require'lspconfig'.denols.setup{}
require'lspconfig'.dhall_lsp_server.setup{}
require'lspconfig'.diagnosticls.setup{}
require'lspconfig'.digestif.setup{}
require'lspconfig'.djlsp.setup{}
require'lspconfig'.docker_compose_language_service.setup{}
require'lspconfig'.dockerls.setup{}
require'lspconfig'.dolmenls.setup{}
require'lspconfig'.dotls.setup{}
require'lspconfig'.dprint.setup{}
require'lspconfig'.drools_lsp.setup{}
require'lspconfig'.ds_pinyin_lsp.setup{}
require'lspconfig'.earthlyls.setup{}
require'lspconfig'.ecsact.setup{}
require'lspconfig'.efm.setup{}
require'lspconfig'.elixirls.setup{}
require'lspconfig'.elmls.setup{}
require'lspconfig'.elp.setup{}
require'lspconfig'.ember.setup{}
require'lspconfig'.emmet_language_server.setup{}
require'lspconfig'.emmet_ls.setup{}
require'lspconfig'.erg_language_server.setup{}
require'lspconfig'.erlangls.setup{}
require'lspconfig'.esbonio.setup{}
require'lspconfig'.eslint.setup{}
require'lspconfig'.facility_language_server.setup{}
require'lspconfig'.fennel_language_server.setup{}
require'lspconfig'.fennel_ls.setup{}
require'lspconfig'.fish_lsp.setup{}
require'lspconfig'.flow.setup{}
require'lspconfig'.flux_lsp.setup{}
require'lspconfig'.foam_ls.setup{}
require'lspconfig'.fortls.setup{}
require'lspconfig'.fsautocomplete.setup{}
require'lspconfig'.fsharp_language_server.setup{}
require'lspconfig'.fstar.setup{}
require'lspconfig'.futhark_lsp.setup{}
require'lspconfig'.gdscript.setup{}
require'lspconfig'.gdshader_lsp.setup{}
require'lspconfig'.ghcide.setup{}
require'lspconfig'.ghdl_ls.setup{}
require'lspconfig'.ginko_ls.setup{}
require'lspconfig'.gitlab_ci_ls.setup{}
require'lspconfig'.gleam.setup{}
require'lspconfig'.glint.setup{}
require'lspconfig'.glsl_analyzer.setup{}
require'lspconfig'.glslls.setup{}
require'lspconfig'.golangci_lint_ls.setup{}
require'lspconfig'.gopls.setup{}
require'lspconfig'.gradle_ls.setup{}
require'lspconfig'.grammarly.setup{}
require'lspconfig'.graphql.setup{}
require'lspconfig'.groovyls.setup{}
require'lspconfig'.guile_ls.setup{}
require'lspconfig'.harper_ls.setup{}
require'lspconfig'.haxe_language_server.setup{}
require'lspconfig'.hdl_checker.setup{}
require'lspconfig'.helm_ls.setup{}
require'lspconfig'.hhvm.setup{}
require'lspconfig'.hie.setup{}
require'lspconfig'.hlasm.setup{}
require'lspconfig'.hls.setup{}
require'lspconfig'.hoon_ls.setup{}
require'lspconfig'.html.setup{}
require'lspconfig'.htmx.setup{}
require'lspconfig'.hydra_lsp.setup{}
require'lspconfig'.hyprls.setup{}
require'lspconfig'.idris2_lsp.setup{}
require'lspconfig'.intelephense.setup{}
require'lspconfig'.janet_lsp.setup{}
require'lspconfig'.java_language_server.setup{}
require'lspconfig'.jdtls.setup{}
require'lspconfig'.jedi_language_server.setup{}
require'lspconfig'.jinja_lsp.setup{}
require'lspconfig'.jqls.setup{}
require'lspconfig'.jsonls.setup{}
require'lspconfig'.jsonnet_ls.setup{}
require'lspconfig'.julials.setup{}
require'lspconfig'.koka.setup{}
require'lspconfig'.kotlin_language_server.setup{}
require'lspconfig'.lean3ls.setup{}
require'lspconfig'.leanls.setup{}
require'lspconfig'.lelwel_ls.setup{}
require'lspconfig'.lemminx.setup{}
require'lspconfig'.lexical.setup{}
require'lspconfig'.ltex.setup{}
require'lspconfig'.lua_ls.setup{}
require'lspconfig'.luau_lsp.setup{}
require'lspconfig'.lwc_ls.setup{}
require'lspconfig'.m68k.setup{}
require'lspconfig'.markdown_oxide.setup{}
require'lspconfig'.marksman.setup{}
require'lspconfig'.matlab_ls.setup{}
require'lspconfig'.mdx_analyzer.setup{}
require'lspconfig'.mesonlsp.setup{}
require'lspconfig'.metals.setup{}
require'lspconfig'.millet.setup{}
require'lspconfig'.mint.setup{}
require'lspconfig'.mlir_lsp_server.setup{}
require'lspconfig'.mlir_pdll_lsp_server.setup{}
require'lspconfig'.mm0_ls.setup{}
require'lspconfig'.mojo.setup{}
require'lspconfig'.motoko_lsp.setup{}
require'lspconfig'.move_analyzer.setup{}
require'lspconfig'.msbuild_project_tools_server.setup{}
require'lspconfig'.mutt_ls.setup{}
require'lspconfig'.nelua_lsp.setup{}
require'lspconfig'.neocmake.setup{}
require'lspconfig'.nextls.setup{}
require'lspconfig'.nginx_language_server.setup{}
require'lspconfig'.nickel_ls.setup{}
require'lspconfig'.nil_ls.setup{}
require'lspconfig'.nim_langserver.setup{}
require'lspconfig'.nimls.setup{}
require'lspconfig'.nixd.setup{}
require'lspconfig'.nomad_lsp.setup{}
require'lspconfig'.ntt.setup{}
require'lspconfig'.nushell.setup{}
require'lspconfig'.nxls.setup{}
require'lspconfig'.ocamlls.setup{}
require'lspconfig'.ocamllsp.setup{}
require'lspconfig'.ols.setup{}
require'lspconfig'.omnisharp.setup{}
require'lspconfig'.opencl_ls.setup{}
require'lspconfig'.openedge_ls.setup{}
require'lspconfig'.openscad_ls.setup{}
require'lspconfig'.openscad_lsp.setup{}
require'lspconfig'.pact_ls.setup{}
require'lspconfig'.pasls.setup{}
require'lspconfig'.pbls.setup{}
require'lspconfig'.perlls.setup{}
require'lspconfig'.perlnavigator.setup{}
require'lspconfig'.perlpls.setup{}
require'lspconfig'.pest_ls.setup{}
require'lspconfig'.phan.setup{}
require'lspconfig'.phpactor.setup{}
require'lspconfig'.pico8_ls.setup{}
require'lspconfig'.pkgbuild_language_server.setup{}
require'lspconfig'.please.setup{}
require'lspconfig'.postgres_lsp.setup{}
require'lspconfig'.powershell_es.setup{}
require'lspconfig'.prismals.setup{}
require'lspconfig'.prolog_ls.setup{}
require'lspconfig'.prosemd_lsp.setup{}
require'lspconfig'.protols.setup{}
require'lspconfig'.psalm.setup{}
require'lspconfig'.pug.setup{}
require'lspconfig'.puppet.setup{}
require'lspconfig'.purescriptls.setup{}
require'lspconfig'.pylsp.setup{}
require'lspconfig'.pylyzer.setup{}
require'lspconfig'.pyre.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.qml_lsp.setup{}
require'lspconfig'.qmlls.setup{}
require'lspconfig'.quick_lint_js.setup{}
require'lspconfig'.r_language_server.setup{}
require'lspconfig'.racket_langserver.setup{}
require'lspconfig'.raku_navigator.setup{}
require'lspconfig'.reason_ls.setup{}
require'lspconfig'.regal.setup{}
require'lspconfig'.regols.setup{}
require'lspconfig'.relay_lsp.setup{}
require'lspconfig'.remark_ls.setup{}
require'lspconfig'.rescriptls.setup{}
require'lspconfig'.rls.setup{}
require'lspconfig'.rnix.setup{}
require'lspconfig'.robotframework_ls.setup{}
require'lspconfig'.roc_ls.setup{}
require'lspconfig'.rome.setup{}
require'lspconfig'.rubocop.setup{}
require'lspconfig'.ruby_lsp.setup{}
require'lspconfig'.ruff.setup{}
require'lspconfig'.ruff_lsp.setup{}
require'lspconfig'.rune_languageserver.setup{}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.salt_ls.setup{}
require'lspconfig'.scheme_langserver.setup{}
require'lspconfig'.scry.setup{}
require'lspconfig'.serve_d.setup{}
require'lspconfig'.shopify_theme_ls.setup{}
require'lspconfig'.sixtyfps.setup{}
require'lspconfig'.slangd.setup{}
require'lspconfig'.slint_lsp.setup{}
require'lspconfig'.smarty_ls.setup{}
require'lspconfig'.smithy_ls.setup{}
require'lspconfig'.snyk_ls.setup{}
require'lspconfig'.solang.setup{}
require'lspconfig'.solargraph.setup{}
require'lspconfig'.solc.setup{}
require'lspconfig'.solidity.setup{}
require'lspconfig'.solidity_ls.setup{}
require'lspconfig'.solidity_ls_nomicfoundation.setup{}
require'lspconfig'.somesass_ls.setup{}
require'lspconfig'.sorbet.setup{}
require'lspconfig'.sourcekit.setup{}
require'lspconfig'.sourcery.setup{}
require'lspconfig'.spectral.setup{}
require'lspconfig'.spyglassmc_language_server.setup{}
require'lspconfig'.sqlls.setup{}
require'lspconfig'.sqls.setup{}
require'lspconfig'.standardrb.setup{}
require'lspconfig'.starlark_rust.setup{}
require'lspconfig'.starpls.setup{}
require'lspconfig'.statix.setup{}
require'lspconfig'.steep.setup{}
require'lspconfig'.stimulus_ls.setup{}
require'lspconfig'.stylelint_lsp.setup{}
require'lspconfig'.svelte.setup{}
require'lspconfig'.svlangserver.setup{}
require'lspconfig'.svls.setup{}
require'lspconfig'.swift_mesonls.setup{}
require'lspconfig'.syntax_tree.setup{}
require'lspconfig'.tabby_ml.setup{}
require'lspconfig'.tailwindcss.setup{}
require'lspconfig'.taplo.setup{}
require'lspconfig'.tblgen_lsp_server.setup{}
require'lspconfig'.teal_ls.setup{}
require'lspconfig'.templ.setup{}
require'lspconfig'.terraform_lsp.setup{}
require'lspconfig'.terraformls.setup{}
require'lspconfig'.texlab.setup{}
require'lspconfig'.textlsp.setup{}
require'lspconfig'.tflint.setup{}
require'lspconfig'.theme_check.setup{}
require'lspconfig'.thriftls.setup{}
require'lspconfig'.tilt_ls.setup{}
require'lspconfig'.tinymist.setup{}
require'lspconfig'.tsp_server.setup{}
require'lspconfig'.tsserver.setup{}
require'lspconfig'.ttags.setup{}
require'lspconfig'.turtle_ls.setup{}
require'lspconfig'.twiggy_language_server.setup{}
require'lspconfig'.typeprof.setup{}
require'lspconfig'.typos_lsp.setup{}
require'lspconfig'.typst_lsp.setup{}
require'lspconfig'.uiua.setup{}
require'lspconfig'.unison.setup{}
require'lspconfig'.unocss.setup{}
require'lspconfig'.uvls.setup{}
require'lspconfig'.v_analyzer.setup{}
require'lspconfig'.vacuum.setup{}
require'lspconfig'.vala_ls.setup{}
require'lspconfig'.vale_ls.setup{}
require'lspconfig'.vdmj.setup{}
require'lspconfig'.verible.setup{}
require'lspconfig'.veridian.setup{}
require'lspconfig'.veryl_ls.setup{}
require'lspconfig'.vhdl_ls.setup{}
require'lspconfig'.vimls.setup{}
require'lspconfig'.visualforce_ls.setup{}
require'lspconfig'.vls.setup{}
require'lspconfig'.volar.setup{}
require'lspconfig'.vtsls.setup{}
require'lspconfig'.vuels.setup{}
require'lspconfig'.wgsl_analyzer.setup{}
require'lspconfig'.yamlls.setup{}
require'lspconfig'.yang_lsp.setup{}
require'lspconfig'.yls.setup{}
require'lspconfig'.zk.setup{}
require'lspconfig'.zls.setup{}

require'oil'.setup{}
require 'nvim-surround'.setup{}
require'Comment'.setup{}
require'nvim-autopairs'.setup{}

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
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)

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
