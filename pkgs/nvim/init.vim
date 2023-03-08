" Remap leader key
nmap <Space> <leader>

" Telescope binds
nnoremap <silent> <leader>f :Telescope find_files<cr>
nnoremap <silent> <leader>b :Telescope buffers<cr>
nnoremap <silent> <leader>g :Telescope live_grep<cr>

colorscheme gruvbox

" So that neovim follows the transparency rules of alacritty
" hi Normal ctermbg=NONE guibg=NONE

" Conceal latex
set conceallevel=2
let g:tex_conceal="abdmg"

" Use system clipboard
set clipboard=unnamedplus

" Enable file type detection and do language-dependent indenting.
filetype plugin indent on
" Make backspace behave in a sane manner.	
set backspace=indent,eol,start


" Switch syntax highlighting on
syntax on

"Ignore case when searching
set ignorecase
"When searching be smart about cases
set hlsearch
"Make search like in modern browsers
set incsearch
"Regular expressions search
set magic
"Clear search higlighting with esc
nnoremap <silent> <esc> :noh<CR><esc>

"Persistent undo (into ~/.local/share/nvim/undo)
set undofile

"Relative line numbers
set number relativenumber numberwidth=1
"Always show debug sign column
set signcolumn=yes
"Color signcolumn correctly
hi SignColumn guibg=bg

"Indendation
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent
autocmd FileType nix setlocal tabstop=2 softtabstop=2 shiftwidth=2 cindent cinkeys-=0#

"Wrap lines
set wrap linebreak nolist

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
nnoremap <leader>i :e $HOME/documents/wiki/index.md<cr>
":W doas saves file
command! W silent execute 'w !doas tee % > /dev/null' <bar> edit!

"Disable automatic commenting on new line
" autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"Make split windows open at the bottom
set splitbelow splitright
