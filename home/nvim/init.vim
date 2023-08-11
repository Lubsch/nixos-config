" Remap leader key
nmap <Space> <leader>
nmap <leader> <localleader>

set mousescroll=ver:1

" TODO replace with nix
colorscheme gruvbox

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
