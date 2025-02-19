set encoding=utf-8
lang en_US.UTF-8
set expandtab
set ts=2
set sw=2
set sts=2
set autoindent
set nu
set list
set listchars=tab:→\ ,eol:¬,nbsp:·,trail:•,extends:⟩,precedes:⟨
set modeline
set wrap
set hlsearch
set incsearch
set backspace=indent,eol,start
set foldenable
filetype indent plugin on
syntax enable

autocmd TerminalOpen * call OnTerminalOpen()
function OnTerminalOpen()
  set nonu
  set listchars=tab:→\ ,nbsp:·,trail:•
  set showbreak=""
endfunction

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.colnr = ' co:'
let g:airline_symbols.linenr = ' ln:'

let NERDTreeCaseSensitiveSort = 1
nmap <leader>ff <cmd>FZF<CR>
