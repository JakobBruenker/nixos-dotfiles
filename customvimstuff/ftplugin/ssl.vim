setlocal nobackup
setlocal noswapfile
setlocal noundofile
set cmdheight=2

function! s:isEmpty()
    return line('$') == 1 && getline(1) ==? ''
endfunction

function! s:getPassword()
    if s:isEmpty()
        echo 'New file, enter password:'
    else
        echo 'Enter password:'
    endif
    let s:passwd = ''
    let char = getchar()
    while char != 13
        let s:passwd = s:passwd . nr2char(char)
        let char = getchar()
    endwhile
    if s:isEmpty()
        echo 'Verify password:'
        let verPasswd = ''
        let char = getchar()
        while char != 13
            let verPasswd = verPasswd . nr2char(char)
            let char = getchar()
        endwhile
        if s:passwd !=# verPasswd
            qa!
        endif
    endif
endfunction

function! s:decrypt(exitOnError)
    if !s:isEmpty()
        exe 'silent %!openssl enc -d -aes-256-cbc -a -k ''' . s:passwd . ''''
    endif
    if a:exitOnError && v:shell_error != 0
        qa!
    endif
endfunction

function! s:encrypt(exitOnError)
    exe 'silent %!openssl enc -aes-256-cbc -a -k ''' . s:passwd . ''''
    if a:exitOnError && v:shell_error != 0
        qa!
    endif
endfunction

augroup SSL
    autocmd!
    autocmd VimEnter *.ssl call s:getPassword()|call s:decrypt(1)
    autocmd BufReadPost *.ssl :call s:decrypt(0)
    autocmd BufReadPost *.ssl |redraw!
    autocmd BufWritePre *.ssl :call s:encrypt(1)
    autocmd BufWritePost *.ssl :exe "normal uG$"
augroup END
