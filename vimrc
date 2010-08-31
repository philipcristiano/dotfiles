set tabstop=4
set softtabstop=4
set expandtab  
set number
set autoindent
set incsearch
set hlsearch
autocmd FileType make setlocal noexpandtab
setlocal spell spelllang=en_us
set nospell


colorscheme slate

autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

filetype plugin on
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

