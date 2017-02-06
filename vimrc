" pathogen settings
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

" general settings
syntax on
filetype plugin indent on
set hlsearch  " highlight all search patterns matches
map <F2> :echo 'Current time is ' . strftime('%c')<CR>
" some copy and paste sanity
map <F4> :set paste! nopaste?<CR>
map <F3> :noh<CR>
noremap <leader>y "*y<CR>
noremap <leader>p "*p<CR>
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab " tab options
set number  " line numbers

" setup a more modern search behavior
set ignorecase
set smartcase
set incsearch

" base16-bash/vim settings
if filereadable(expand("~/.vimrc_background"))  " requires base16-bash to be installed
  let base16colorspace=256  " Access colors present in 256 colorspace
  source ~/.vimrc_background
endif

" NERDTree
map <leader>n :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.rbc$', '\.rbo$', '\.class$', '\.o$', '\~$']

" vim-airline
let g:airline_powerline_fonts = 1
set laststatus=2  " puts airline in the right spot when used with NERDTree

