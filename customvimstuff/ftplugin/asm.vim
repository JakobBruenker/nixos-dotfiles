setlocal textwidth=79
setlocal smartindent
setlocal autoindent
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal expandtab

setlocal commentstring=;\ %s

setlocal nospell

let g:easy_align_ignore_groups = []

nnoremap ,s. vip:EasyAlign<CR><C-X>;<CR>
vnoremap ,s. :EasyAlign<CR><C-X>;<CR>
