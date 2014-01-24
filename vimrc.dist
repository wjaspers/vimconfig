"
" Fish isn't POSIX compliant
" and many vim commands expect it.
" Switch shells in vim to avoid errors.
"
if &shell =~# 'fish$'
   set shell=sh
endif


"
" Set your preferred color scheme
"
colorscheme elflord


"
" And now add pathogen!
"
execute pathogen#infect()
syntax on
filetype on


"
" Set filetypes by extension
"
autocmd BufNewFile,BufRead *.php set filetype=php
autocmd BufNewFile,BufRead *.sql set filetype=sql
autocmd BufNewFile,BufRead *.yml set filetype=yaml
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.xml set filetype=xml
autocmd BufNewFile,BufRead *.js set filetype=javascript
autocmd BufNewFile,BufRead *.htm* set filetype=html
autocmd BufNewFile,BufRead *.conf set filetype=conf


"
" Add special configuration for plugins
"
let g:tagbar_phpctags_bin='~/.vim/.bin/tagbar-phpctags'
let g:tagbar_phpctags_memory_limit='128M'


"
" Folding settings
"
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use


"
" Tabs
"
set expandtab 			"many languages rely on spaces instead of tabs
set tabstop=4			"indent with 4 spaces


"
" And now the fun part, key bindings!
"

" hide/show the tagbar by pressing a key.
nmap <F8> :TagbarToggle<CR>
