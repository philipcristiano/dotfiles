set tabstop=4
set softtabstop=4
set expandtab  
set number
set autoindent
autocmd FileType make setlocal noexpandtab
setlocal spell spelllang=en_us
set nospell


colorscheme slate

autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
