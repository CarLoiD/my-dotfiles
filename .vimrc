" #Editor settings

syntax on

set background=dark
colorscheme zx 

" Transparent background
" hi Normal ctermbg=NONE guibg=NONE
" hi EndOfBuffer cterm=NONE guibg=NONE
" hi NonText cterm=NONE guibg=NONE

set smartindent
set autoindent
set expandtab 
set smarttab
set number relativenumber
set splitright
set splitbelow
set tabstop=4
set shiftwidth=4

" Do not create any swap files
set noswapfile

" Status bar settings
set laststatus=2

set statusline=%1* 
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %l:%c
set statusline+=\ %p%%
set statusline+=\ 

let g:cpp_function_highlight = 0
let g:cpp_attributes_highlight = 1

" Highlight struct/class member variables (affects both C and C++ files)
let g:cpp_member_highlight = 1

" Highlight operators (affects both C and C++ files)
let g:cpp_operator_highlight = 1

" Put all standard C and C++ keywords under Vim's highlight group 'Statement'
let g:cpp_simple_highlight = 0

autocmd BufNewFile *.c,*.h,*.hpp,*.cpp,*.cc,*.cmake,CMakeLists.txt call s:License()
autocmd FileType make setlocal noexpandtab

augroup number_toggle
    autocmd!
    autocmd BufEnter,FocusGained,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,WinLeave   * if &nu                  | set nornu | endif
augroup END

" #Functions

function! s:License()
    silent! 0r ~/.vim/skeletons/apache2_0

    silent! %s/<year>/\=strftime("%Y")/g
    silent! %s/<author>/Carlos Gurgel/g
    silent! %s/<file>/\=expand("%:t")/g

    if &filetype ==# 'c' || &filetype ==# 'cpp' || &filetype ==# 'cc' || &filetype ==# 'h' || &filetype ==# 'hpp'
        silent! %s/<comment>/\/\//g
    else
        silent! %s/<comment>/#/g
    endif

    " Go to the end of buffer
    normal! G
    
    let l:ext = expand("%:e")
    let l:is_header = (l:ext ==# "h") || (l:ext ==# "hpp")

    let l:guard_h = ""
    if l:ext ==# "h"
        let l:guard_h = "_H_"
    elseif l:ext ==# "hpp"
        let l:guard_h = "_HPP_"
    endif

    if l:is_header
        " Insert header guards
        " Replace non alpha-numeric to underline
        let l:guard  = substitute(toupper(expand("%:r")), '[^A-Z0-9]', '_', 'g') 
        let l:guard .= l:guard_h
        let l:fguard = substitute(l:guard, '^SRC_', '', '')

        call append(line("$"), "#ifndef " . l:fguard)
        call append(line("$"), "#define " . l:fguard)
        call append(line("$"), "#endif // " . l:fguard)

        " Jump the end of buffer and append a line upwards
        call cursor(line("$"), 1)
        normal! O
    endif
endfunction

function! GitAutoPushImpl()
    execute "!changes=$(git diff --shortstat) &&"
        \ "date_time=$(date) &&"
        \ "message=\"$date_time -- $changes\" &&"
        \ "git add . && git commit -m \"$message\" && git push"
endfunction

function! AnotherWindowCmd(cmd_if_two, cmd_if_one)
    if winnr('$') == 2
        wincmd w
        execute a:cmd_if_two
    else
        execute a:cmd_if_one
    endif
endfunction

function! OpenAnotherWindow()
    if winnr('$') == 2
        wincmd w
    else
        vs
        enew
    endif
endfunction

function! FindFile(dir)
    let fd_cmd  = 'find ' . a:dir . ' -type f -not -name "*.elf" '
    let fd_cmd .= '-type f -not -name "*.o" '
    let fd_cmd .= '-type f -not -name "*.d" '
    let fd_cmd .= '-not -path "./obj/*" ' 
    let fd_cmd .= '-not -path "./build/*" ' 
    let fd_cmd .= '-not -path "./.git/*" | tac | '

    let sd_cmd = 'sed "s|^\./||"'
    let cmd = fd_cmd . sd_cmd

    let temp = tempname()
    execute 'silent !' . cmd . ' | fzf --preview "cat {}" > ' . fnameescape(temp)
    while !filereadable(temp)
        sleep 10m
    endwhile

    let result = readfile(temp)
    if empty(result)
        redraw!
        return
    endif

    try
        execute 'edit ' . fnameescape(result[0])
        redraw!
    finally
        call delete(temp)
    endtry
endfunction

function! GetRelativeFile()
    let bufname = expand('%:p')
    let ext = fnamemodify(bufname, ':e')
    let base = fnamemodify(bufname, ':r')
    let swap = ''

    if empty(ext) 
        return swap
    endif
    
    if ext == 'cpp' || ext == 'c' || ext == 'inl'
        let swap = base . '.h'
    elseif ext == 'h'
        if filereadable(base . '.cpp')
            let swap = base . '.cpp'
        elseif filereadable(base . '.inl')
            let swap = base . '.inl'
        else
            let swap = base . '.c'
        endif
    endif

    return swap 
endfunction

function! OpenRelativeFile()
    let swap = GetRelativeFile()

    if empty(swap)
        echo 'Current file is not a C or C++ header/source file'
        return
    endif

    execute 'e ' . swap
endfunction

function! OpenRelativeFileAnotherWindow()
    let swap = GetRelativeFile()

    if empty(swap)
        echo 'Current file is not a C or C++ header/source file'
        return
    endif

    call AnotherWindowCmd('edit % | e ' . swap, 'vs ' . swap)
endfunction

function! NewFileAnotherWindow()
    call AnotherWindowCmd('enew', 'vs | enew')
endfunction

function! LiveGrep()
    let temp = tempname()

    execute 'silent !rg --line-number . | fzf > ' . fnameescape(temp)
    while !filereadable(temp)
        sleep 10m
    endwhile

    let result = readfile(temp)
    if empty(result)
        redraw!
        return
    endif

    let sub = split(result[0], ":")
    try
        execute 'e +' . sub[1] . ' ' . fnameescape(sub[0])
        redraw!
    finally
        call delete(temp)
    endtry
endfunction

function! FindFileProject()
    call FindFile('./')
endfunction

function! FindFilePS2SDK()
    call FindFile('$PS2SDK/ee/include $PS2SDK/iop/include $PS2SDK/common/include')
endfunction

function! LiveGrepAnotherWindow()
    call OpenAnotherWindow()
    call LiveGrep()
endfunction

function! FindFileProjectAnotherWindow()
    call OpenAnotherWindow()
    call FindFileProject()
endfunction

" #Commands

command! -nargs=1 GitPush !git add . && git commit -m <f-args> && git push
command! -nargs=0 GitAutoPush call GitAutoPushImpl()

" #Remaps

" Fix WSL1 weird bug, stop starting in replace mode
nnoremap <esc>^[ <esc>^[

" Auto close scopes
inoremap "<Tab> ""<left>
inoremap '<Tab> ''<left>
inoremap (<Tab> ()<left>
inoremap [<Tab> []<left>
inoremap {<Tab> {}<left>
inoremap <<Tab> <><left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Misc targets 
nnoremap <F5> :!clear && cmake.exe --build build/ --target run<CR>
nnoremap <F6> :!clear && make run_hardware<CR>
nnoremap <F7> :!clear && make run_emulator<CR>
nnoremap <F9> :!clear && rm -rf build/ && cmake.exe -B build/ -G "Ninja"<CR>
nnoremap <F10> :GitAutoPush<CR>
nnoremap <C-J> :call LiveGrep()<CR>
nnoremap <C-K> :call FindFileProject()<CR>
nnoremap <C-L> :call FindFilePS2SDK()<CR>
nnoremap <S-Q> :call OpenRelativeFile()<CR>
nnoremap <S-W> :call OpenRelativeFileAnotherWindow()<CR>
nnoremap <S-E> :call NewFileAnotherWindow()<CR>

nnoremap <C-U> :call FindFileProjectAnotherWindow()<CR>
