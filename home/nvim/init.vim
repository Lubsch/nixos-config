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
":W sudo saves file
command! W silent execute 'w !sudo tee % > /dev/null' <bar> edit!
"Use quickfix list comfortably
nnoremap <leader>n :cnext
nnoremap <leader>p :cprev
