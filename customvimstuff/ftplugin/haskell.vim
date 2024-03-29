" the period is for hothasktags
" set iskeyword+=.,39
" using fasttags now
set iskeyword+=39

" {{{ ghcid

let g:ghcid_command = "ghcid -c 'cabal new-repl --ghc-options=-fdiagnostics-color=always' --test=':!hlint src && cabal new-test' --color=always --reload=test --restart=package.yaml"
let g:ghcid_keep_open = 1
'
function! OpenGhcid()
    :Ghcid
    execute "normal \<C-w>H\<C-w>l"
    setlocal nospell
    execute "normal \<C-w>h"
endfunction

" nnoremap <silent> <localleader><localleader>m :w<CR>:call OpenGhcid()<CR>
" inoremap <silent> <localleader><localleader>m :w<CR>:call OpenGhcid()<CR>

" }}}

" {{{ necoghc

" Disable haskell-vim omnifunc
" let g:haskellmode_completion_ghc = 0
" autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
" let g:necoghc_enable_detailed_browse = 1

" }}}

" {{{ neomake

" function! HsMake()
"     call QuickfixOpen()
"     Neomake!
" endfunction

" nnoremap <silent> <localleader><localleader>m :w<CR>:call HsMake()<CR>
" inoremap <silent> <localleader><localleader>m <ESC>:w<CR>:call HsMake()<CR>

" augroup Neomake
"     autocmd!
"     autocmd BufWritePost *.hs call jobstart(['bash', '-O', 'globstar', '-c', 'hothasktags ./**/*.hs > tags'])
"     autocmd BufWritePost *.hs AirlineRefresh
" augroup END

" let &makeprg = 'stack build --exec "hlint src"'

" }}}

" {{{ Assorted settings

" I'm not actually using the session, it seems
" augroup Session
"     autocmd BufCreate * mksession! .session.vim
"     autocmd BufLeave * mksession! .session.vim
"     autocmd BufEnter * mksession! .session.vim
"     autocmd QuitPre * TagbarClose
"     autocmd QuitPre * NERDTreeClose
"     autocmd QuitPre * call QuickfixClose()
"     autocmd QuitPre * helpclose
"     autocmd VimLeavePre * mksession! .session.vim
" augroup END

setlocal textwidth=79
setlocal smartindent
setlocal autoindent
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal expandtab

" lua require'lspconfig'.hls.setup{cmd = {"haskell-language-server", "--lsp"}}
  " cmd = { "haskell-language-server-wrapper", "--lsp" }
  " filetypes = { "haskell", "lhaskell" }
  " lspinfo = function (cfg)
  "       -- return "specific"
  "       if cfg.settings.languageServerHaskell.logFile or false then
  "         return "logfile: "..cfg.settings.languageServerHaskell.logFile
  "       end
  "       return ""
  "     end;
  " root_dir = root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml")
  " settings = {
  "   languageServerHaskell = {
  "     formattingProvider = "ormolu"
  "   }
  " }
" }

" }}}

" {{{ Assorted mappings

nnoremap ,s. vip:EasyAlign<CR><C-X>-><CR>
vnoremap ,s. :EasyAlign<CR><C-X>-><CR>

inoremap <LocalLeader>; <ESC>yypA<Space><ESC>kA<Space>::<Space>
inoremap u. <Space>-><Space>
inoremap ,u <Space><-<Space>
inoremap ;; <Space>::<Space>

" }}}

" {{{ Colorstuff

highlight Special cterm=italic
highlight hsModuleName ctermfg=6 cterm=italic
highlight hsImportLabel ctermfg=5
highlight hsModuleStartLabel ctermfg=2
highlight hsStructure ctermfg=2
highlight hsStatement ctermfg=2
highlight hsVarSym ctermfg=2
highlight hsString ctermfg=9 cterm=italic
highlight hsNumber ctermfg=6 cterm=italic
highlight hsFloat ctermfg=6 cterm=italic
highlight hs_DeclareFunction ctermfg=2
highlight hsDelimiter ctermfg=1
highlight hsCharacter ctermfg=6 cterm=italic
highlight QuickFixLine ctermbg=NONE ctermfg=7
highlight ErrorSign ctermfg=1
highlight WarningSign ctermfg=1

" }}}
