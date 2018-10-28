" {{{ Highlighting

" if exists('b:current_syntax')
" 	finish
" endif

" syntax match hsType /\v(λ(\n*.*)*|it :: .*)@<=\u\w+/
" syntax match tHsSpecial /\v(λ(\n*.*)*|it :: .*)@<=[[\](){},]/
" syntax match tHsNumber /\v(λ(\n*.*)*|it :: .*)@<=\d+(\.\d+)?(e\d+)?/
" syntax region tHsString start=/"/ skip=/\\\\\|\\/ end=/"/
" syntax match tHsIden /\v(λ(\n*.*)*|it :: .*)@<=\l\w*/
" syntax match tHsIden /\vit( ::)@=/
" syntax match tHsIden /\vid( ::)@=/
" syntax match tHsOperator /\v(λ(\n*.*)*|it :: .*)@<=[:<>&|@=/$*+-]+/
" syntax region tHsOperator start=/`/ end=/\v`| /
" syntax match tHsOperator /\v(it )@<=::/

" highlight tHsSpecial ctermfg=1
" highlight tHsNumber cterm=italic ctermfg=6
" highlight tHsString cterm=italic ctermfg=9
" highlight tHsIden ctermfg=4
" highlight tHsOperator ctermfg=2

" let b:current_syntax = 'terminal'

" }}}
