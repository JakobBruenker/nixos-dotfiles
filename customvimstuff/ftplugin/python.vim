set shiftwidth=4
set tabstop=4
set autoindent
set expandtab

function! SetEntryType(entry)
	if a:entry.type ==? 'F'
		let a:entry.type = 'E'
	elseif a:entry.type ==? 'N'
		let a:entry.type = 'I'
	elseif a:entry.type ==? 'C' || a:entry.type ==? ''
		let a:entry.type = 'M'
	endif
	" remove extraneous newlines
	let a:entry.text = substitute(a:entry.text, '', '', 'g')
	" add non-visible space to end of empty lines to prevent line-ending
	" space from showing up (unicode 2002)
	if a:entry.text ==? ''
		let a:entry.text = ' '
	endif
endfunction

let g:neomake_pylint_maker = {
	\ 'exe': 'pylint',
	\ 'args': expand('%:p:h'),
	\ 'errorformat': '%f:%l:%c: %t%n: %m',
	\ 'postprocess': function('SetEntryType'),
	\ }

let g:neomake_mypy_maker = {
	\ 'exe': 'mypy',
	\ 'args': expand('%:p:h'),
	\ 'errorformat': '%f:%l: %trror: %m, %f:%l: %tote: %m',
	\ 'postprocess': function('SetEntryType'),
	\ }

let g:neomake_flake8_maker = {
	\ 'exe': 'flake8',
	\ 'args': expand('%:p:h'),
	\ 'errorformat': '%f:%l:%c: %t%n %m',
	\ 'postprocess': function('SetEntryType'),
	\ }

" augroup Python
" 	autocmd!
" 	autocmd BufWritePost *.py call PythonNeomake()
" augroup END

nnoremap <localleader><localleader>m :w<CR>:call <SID>PythonNeomake()<CR>
inoremap <localleader><localleader>m :w<CR>:call <SID>PythonNeomake()<CR>

function! s:PythonNeomake()
	call QuickfixOpen()
	Neomake! mypy pylint flake8
endfunction

inoremap u. <Space>-><Space>
