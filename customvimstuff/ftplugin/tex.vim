highlight TexStatement ctermbg=NONE
highlight TexMathMatcher ctermbg=NONE
highlight TexMathZoneX ctermbg=NONE

setlocal textwidth=79
setlocal smartindent
setlocal autoindent
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal expandtab

" {{{ vimtex stuff

if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#omni#input_patterns.tex = '\\(?:'
            \ .  '\w*cite\w*(?:\s*\[[^]]*\]){0,2}\s*{[^}]*'
            \ . '|\w*ref(?:\s*\{[^}]*|range\s*\{[^,}]*(?:}{)?)'
            \ . '|hyperref\s*\[[^]]*'
            \ . '|includegraphics\*?(?:\s*\[[^]]*\]){0,2}\s*\{[^}]*'
            \ . '|(?:include(?:only)?|input)\s*\{[^}]*'
            \ . '|\w*(gls|Gls|GLS)(pl)?\w*(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
            \ . '|includepdf(\s*\[[^]]*\])?\s*\{[^}]*'
            \ . '|includestandalone(\s*\[[^]]*\])?\s*\{[^}]*'
            \ .')'

"let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'zathura'

augroup LatexErrors
    autocmd!
    autocmd BufWritePost *.tex VimtexLacheck
    autocmd BufWritePost *.tex call <SID>CheckErrors()
    autocmd BufWritePost *.tex AirlineRefresh
augroup END

function! s:CheckErrors()
    if exists(':VimtexErrors')
        VimtexErrors
    else
        echom "Couldn't find :VimtexErrors!"
    endif
endfunction

" }}}
