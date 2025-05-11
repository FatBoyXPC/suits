call plug#begin(g:configPath . '/plugged')

Plug 'junegunn/fzf.vim'
Plug 'jesseleite/vim-agriculture'

Plug 'noahfrederick/vim-laravel'
Plug 'tpope/vim-projectionist'



" spelunker went away because noevim has built in spellchecking in comments.
" That's why I added set spell to myrc
"
"Also, traces.vim is natively supported in neovim!
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()
