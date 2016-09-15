" pathogen settings
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

" general settings...I think?
syntax on
filetype plugin indent on

" base16-bash/vim settings
if filereadable(expand("~/.vimrc_background")) " requires base16-bash to be installed
  let base16colorspace=256 " Access colors present in 256 colorspace
  source ~/.vimrc_background
endif

" NERDTree
map <leader>n :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.rbc$', '\.rbo$', '\.class$', '\.o$', '\~$']

" vim-airline
let g:airline_powerline_fonts = 1
