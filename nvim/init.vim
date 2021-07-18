" {{{ VARIOUS SETTINGS

set nofoldenable
set ignorecase
set smartcase

set textwidth=79
set smartindent
set autoindent
set softtabstop=2
set shiftwidth=2
set expandtab

set nohlsearch

set undofile

set completeopt=longest,menuone,preview

set virtualedit=block

" Display all matching files when tab completing
set wildignore+=tags
set wildmenu
set wildmode=longest:full

set inccommand=split

let maplocalleader = ","
let mapleader      = ","

set textwidth=79

" We can see the mode in airline anyway
set noshowmode

set list listchars=tab:├╶,trail:·,nbsp:␣
let &showbreak=' ↪'
set breakindent

set scrolloff=4

set hidden
set spell
set nojoinspaces

set matchpairs+=<:>

set pastetoggle=<F10>

let &fillchars = 'vert: ,fold:·'

" if mouse=a, remember to hold shift to get regular terminal copy
" functionality back
set mouse=a

augroup SignCol
        autocmd!
        autocmd BufEnter * sign define dummy
        autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
augroup END

" because vim recognizes an empty .tex as plaintex
let g:tex_flavor = 'latex'

" }}}

" {{{ VIMRC HELPERS

" Edit .vimrc
nnoremap <Leader><Leader><Leader>ev :split $MYVIMRC<CR>

" Load .vimrc
nnoremap <Leader><Leader><Leader>lv :source $MYVIMRC<CR>

" }}}

" {{{ PLUGINS

" Automatically download vim plug
" Still have to manually call PlugInstall though, otherwise the window opens
" every time you open vim
if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')

" Make sure to use single quotes

Plug 'aaronbieber/vim-quicktask'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'haya14busa/vim-operator-flashy'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-operator-user'
Plug 'lervag/vimtex'
Plug 'LnL7/vim-nix'
Plug 'majutsushi/tagbar'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'mkitt/tabline.vim'
" Plug 'neomake/neomake'
Plug 'romainl/flattened'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'derekelkins/agda-vim', { 'for': 'agda' }

" Plug 'neovim/nvim-lspconfig', { 'for': 'haskell' }

Plug 'Twinside/vim-haskellFold', { 'for': 'haskell' }
Plug 'itchyny/vim-haskell-indent', { 'for': 'haskell' }
Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim', 'for': 'haskell' }

Plug '~/nixos-dotfiles/customvimstuff'

call plug#end()

" }}}

" {{{ NEOMAKE

let g:neomake_warning_sign = {
            \   'text': '➤',
            \   'texthl': 'Title',
            \ }
let g:neomake_message_sign = {
            \   'text': '➤',
            \   'texthl': 'NeomakeMessageSign',
            \ }

let g:neomake_info_sign = {'text': '➤', 'texthl': 'NeomakeInfoSign'}

let g:neomake_error_sign = {
            \ 'text': '➤',
            \ 'texthl': 'WarningMsg',
            \ }

" }}}

" {{{ QUICKTASK

function! OpenNewTasks()
        QTInit
        if bufnr('#') != -1
                let bfn = bufnr('%')
                :quit
                execute 'buffer ' . bfn
        endif
        normal! Gddddkk^wC
        file TODO.qt
endfunction

function! OpenTasksMapping()
        if filereadable('TODO.qt')
                return ":edit TODO.qt\<CR>gg/\\v^\\s+-\\s+\\zs\<CR>"
        elseif bufnr('TODO.qt') != -1
                return ':buffer ' . bufnr("TODO.qt") . "\<CR>gg/\\v^\\s+-\\s+\\zs\<CR>"
        else
                return ":call OpenNewTasks()\<CR>A"
        endif
endfunction

nnoremap <expr> <silent> <Leader><Leader><Leader>to OpenTasksMapping()
let g:quicktask_snip_path = '~/.quicktaskSnips'

" }}}


" {{{ GITGUTTER

set signcolumn=yes

let g:gitgutter_map_keys = 0
let g:gitgutter_max_signs = 1000

" }}}

" {{{ AIRLINE

let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
        let g:airline_symbols = {}
endif
let g:airline_symbols['maxlinenr'] = ' '
let g:airline_theme = 'luna'
" let g:airline_right_sep = '▝'
" let g:airline_right_sep = '▐'

let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#left_sep = '>'
"let g:airline#extensions#tabline#left_alt_sep = '>'

" }}}

" {{{ MAPPINGS

function! OpenSession()
        let bufnr = bufnr('%')
        if filereadable('.session.vim')
                source .session.vim
                if bufloaded(bufnr)
                        execute 'buffer ' . bufnr
                endif
        else
                echoerr "No session found"
        endif
        unlet bufnr
endfunction

let s:qfopen = 0

function! QuickfixToggle()
        if s:qfopen
                cclose
                let s:qfopen = 0
        else
                rightbelow copen
                wincmd k
                let s:qfopen = 1
        endif
        call ResizeTerm()
endfunction

function! ResizeTerm()
        let pwnr = bufwinnr(bufnr('%'))
        let wnr = bufwinnr(bufnr('term://'))
        if wnr !=# -1
                execute wnr . 'wincmd w'
                resize 30
                execute pwnr . 'wincmd w'
        endif
endfunction!

function! QuickfixOpen()
        if !s:qfopen
                leftabove copen
                wincmd k
                let s:qfopen = 1
        endif
endfunction

function! QuickfixClose()
        cclose
        if s:qfopen
                let s:qfopen = 0
        endif
endfunction

function! CheckFold()
        if foldclosed(line('.')) != -1
                foldopen!
        endif
endfunction

function! OpenLocalFold()
        if foldclosed(line('.')) != -1
                foldopen!
        else
                execute (line('.') + 1) . 'foldopen!'
        endif
endfunction

let s:termopen = 0

function! CloseTerm()
        let tname = bufname('term://')
        if tname !=? ""
                execute 'buffer ' . tname
                bdelete!
        endif
        let s:termopen = 0
endfunction

function! ToggleTerm()
        call QuickfixClose()
        let wnr = bufwinnr(bufnr('term://'))
        if wnr !=# -1
                execute wnr . 'wincmd w'
        else
                if &filetype !=# 'terminal'
                        let s:termopen = 1
                        let tname = bufname('term://')
                        if tname ==? ""
                                belowright 30split term://zsh
                                set nospell
                                set filetype=terminal
                        else
                                execute 'belowright 30split ' . tname
                        endif
                        set nobuflisted
                endif
        endif
endfunction

function! NewTermStuff()
        if &filetype !=# 'terminal'
                if s:termopen
                        return "A"
                else
                        return "Acd " . getcwd() . "\<CR>"
                        let s:termopen = 1
                endif
        else
                return ":q\<CR>"
        endif
endfunction

" nnoremap <silent> <expr> <Leader><Leader>g ":call ToggleTerm()\<CR>" . NewTermStuff()
tnoremap <Leader><Leader>g <C-\><C-N>:q<CR>
tnoremap <Leader><Leader>c <C-\><C-N><C-W>k
tnoremap <Esc>s <C-\><C-N>

nnoremap <silent> <Leader><Leader><Leader>s :call OpenSession()<CR>

nnoremap <Leader>q gwip

function! SearchNote()
    let curLine = getreg("z")
    let note = substitute(curLine, '.*Note \[\(.*\)\].*', '\1', '')
    execute ('lgrep -r "^\s*\({-\\|--\\|\#\)\?\s*Note \[' . note . '\]$" . --exclude=tags')
endfunction

nnoremap <silent> <Leader><Leader>m "zyy:call SearchNote()<CR>
nnoremap <Leader><Leader>g "zyiw:lgrep -rnw <C-R>z . --exclude=tags<CR>
nnoremap <M-LeftMouse>g <LeftMouse>"zyiw:lgrep -rnw <C-R>z . --exclude=tags<CR>

noremap : ;
noremap ; :

vnoremap . :normal .<CR>
vnoremap < <gv
vnoremap > >gv
" imap <expr> <Leader><CR> (pumvisible() ? "<C-Y>" : "") . '<Plug>snipMateNextOrTrigger'

vnoremap <Space> I<Space><Esc>gv
map y <Plug>(operator-flashy)
sunmap y
map Y <Plug>(operator-flashy)$
sunmap Y

nnoremap <silent> Q :call QuickfixToggle()<CR>
nnoremap <silent> <Leader>n :lnext<CR>:call CheckFold()<CR>
nnoremap <silent> <Leader>r :lc<CR>:call CheckFold()<CR>
nnoremap <silent> <Leader>j :lprevious<CR>:call CheckFold()<CR>
" nnoremap <silent> <Leader>ln :lnext<CR>:call CheckFold()<CR>
" nnoremap <silent> <Leader>lr :ll<CR>:call CheckFold()<CR>
" nnoremap <silent> <Leader>lj :lprevious<CR>:call CheckFold()<CR>
nnoremap <silent> <Leader>tb :TagbarToggle<CR>:call ResizeTerm()<CR>

map <Leader>ds <Plug>Dsurround

nnoremap <silent> <Leader>p :CtrlPMixed<CR>

nnoremap <silent> <Leader><Leader>h <C-W>h:bprevious<CR>
nnoremap <silent> <Leader><Leader>n <C-W>h:bnext<CR>
nnoremap <silent> <Leader><Leader>b <C-W>h:bfirst<CR>
nnoremap <C-W>_ <C-W>-
nnoremap <C-W>- <C-W>_
nnoremap <Leader>wm <C-W>h
nnoremap <Leader>wn <C-W>l
nnoremap <Leader>wk <C-W>k
nnoremap <Leader>wj <C-W>j

" split up so that this doesn't activate the mapping itself
nnoremap <silent> <expr> <Leader><Leader><Leader>td '/\vTO' . 'DO\|FI' . 'XME\|X' . "XX\<CR>:call CheckFold()\<CR>"

nnoremap <Leader>o <C-O>
nnoremap <Leader>i <C-I>
nnoremap <Leader><Leader>t <C-]>
nnoremap <Leader><Leader>c <C-t>
nnoremap <silent> <Leader><Leader>f :set foldenable<CR>
nnoremap <silent> <Leader><Leader>y :set nofoldenable<CR>

nnoremap <silent> <Leader><Leader>q :q<CR>
nnoremap <silent> <Leader><Leader>!q :q!<CR>
nnoremap <silent> <Leader><Leader>d :bdelete<CR>
nnoremap <silent> <Leader><Leader>!d :bdelete!<CR>
nnoremap <silent> <Leader><Leader>x :x<CR>
nnoremap <silent> <Leader><Leader>z :qa<CR>
nnoremap <silent> <Leader><Leader>!z :qa!<CR>
nnoremap <silent> <Leader><Leader>w :w<CR>
inoremap <silent> <Leader><Leader>w <Esc>:w<CR>
nnoremap <silent> <Leader><Leader>!w :wa<CR>:echom "All files written"<CR>

nnoremap <leader>P P=']<C-O>

noremap <Leader>+ ;
noremap <Leader>] ,

nnoremap za zA
nnoremap zA za
nnoremap <silent> zo :call OpenLocalFold()<CR>

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

noremap g: g;

function! s:NextOrNewLine()
        return (getline(line('.') + 1) =~? '\v\s+$') ? "\<Esc>jA" : "\<CR>"
endfunction

function! s:NextOrNewLineNormal()
        return (col('.') >= col('$') && getline(line('.') + 1) =~? '\v\s+$') ? "jA" : "i\<CR>"
endfunction

" inoremap <expr> <CR> (pumvisible() ? "<C-Y>" : "") . <SID>NextOrNewLine()

inoremap <expr> <TAB> (pumvisible() ? "<C-N>" : "<TAB>")
inoremap <S-TAB> <C-P>
nnoremap <expr> <Leader><Leader><CR> <SID>NextOrNewLineNormal()

inoremap <Leader>f <C-X><C-F>

" }}}

" {{{ COLORSCHEME

set background=dark

color flattened_dark
highlight Normal ctermbg=NONE
highlight folded cterm=italic ctermbg=NONE
highlight SpecialKey ctermfg=0 ctermbg=NONE
highlight Comment ctermfg=10 cterm=italic
highlight TODO ctermbg=NONE
highlight gitGutterAdd ctermfg=2 ctermbg=NONE
highlight gitGutterChange ctermfg=3 ctermbg=NONE
highlight gitGutterDelete ctermfg=1 ctermbg=NONE
highlight gitGutterChangeDelete ctermfg=3 ctermbg=NONE
highlight LineNr ctermbg=NONE
highlight VertSplit cterm=NONE ctermbg=23
highlight StatusLineNC cterm=NONE ctermbg=23
highlight StatusLine cterm=NONE ctermfg=7 ctermbg=23
highlight TagbarHighlight ctermfg=7 ctermbg=NONE
highlight TagbarSignature ctermfg=13
highlight SpellBad ctermbg=NONE
highlight SpellCap ctermbg=NONE
" highlight EasyMotionTarget2First ctermfg=1
" highlight EasyMotionTarget2Second ctermfg=5
highlight SpellRare cterm=NONE ctermbg=NONE
highlight MatchParen ctermbg=0

augroup Highlighting
        autocmd!
        autocmd BufEnter * highlight airline_tabhid ctermbg=29
augroup END

" get highlight group of word under cursor
nmap <Leader><Leader><Leader>yi :call <SID>SynStack()<CR>

function! <SID>SynStack()
        if !exists("*synstack")
                return
        endif
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

" }}}
