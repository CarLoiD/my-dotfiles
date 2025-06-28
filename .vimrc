" #Editor settings

syntax on

set background=dark
colorscheme retrobox 

" Transparent background
hi Normal ctermbg=NONE guibg=NONE
hi EndOfBuffer cterm=NONE guibg=NONE
hi NonText cterm=NONE guibg=NONE

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

autocmd FileType make setlocal noexpandtab

augroup number_toggle
    autocmd!
    autocmd BufEnter,FocusGained,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,WinLeave   * if &nu                  | set nornu | endif
augroup END

" #Functions

function! GitAutoPushImpl()
    execute "!changes=$(git diff --shortstat) &&"
        \ "date_time=$(date) &&"
        \ "message=\"$date_time -- $changes\" &&"
        \ "git add . && git commit -m \"$message\" && git push"
endfunction

function! CMakeConfigurePS2DebugImpl()
    execute "!clear && rm -rf build/ &&"
        \ "cmake . -B build/ -DCMAKE_BUILD_TYPE=Debug "
        \ "-DPLATFORM=PS2 -DCMAKE_TOOLCHAIN_FILE=cmake/ee-toolchain.cmake"
endfunction

function! CMakeConfigurePS2ReleaseImpl()
    execute "!clear && rm -rf build/ &&"
        \ "cmake . -B build/ -DCMAKE_BUILD_TYPE=Release "
        \ "-DPLATFORM=PS2 -DCMAKE_TOOLCHAIN_FILE=cmake/ee-toolchain.cmake"
endfunction

function! CMakeBuildImpl()
    execute "!clear && cmake --build build/"
endfunction

function! CMakeBuildRunPS2HardwareImpl()
    execute "!clear && cmake --build build/ --target ps2_run_hardware"
endfunction

function! CMakeBuildRunPS2EmulatorImpl()
    execute "!clear && cmake --build build/ --target ps2_run_emulator"
endfunction

function! FindFile(dir)
    let fd_cmd  = 'find ' . a:dir . ' -type f -not -name "*.elf" '
    let fd_cmd .= '-not -path "./external/*" '
    let fd_cmd .= '-not -path "./build/*" ' 
    let fd_cmd .= '-not -path "./.git/*" | '

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
        if filereadable(base . '.c')
            let swap = base . '.c'
        elseif filereadable(base . '.inl')
            let swap = base . '.inl'
        else
            let swap = base . '.cpp'
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

    if winnr('$') == 2
        wincmd w
        edit %
        execute 'e ' . swap
    else
        execute 'vs ' . swap
    endif
endfunction

function! NewFileAnotherWindow()
    if winnr('$') == 2
        wincmd w
        enew
    else
        vs
        enew
    endif
endfunction

function! FindFileProject()
    call FindFile('./')
endfunction

function! FindFilePS2SDK()
    call FindFile('$PS2SDK/ee/include $PS2SDK/iop/include $PS2SDK/common/include')
endfunction

" #Commands

command! -nargs=1 GitPush !git add . && git commit -m <f-args> && git push
command! -nargs=0 GitAutoPush call GitAutoPushImpl()
command! -nargs=0 CMakeConfigurePS2Debug call CMakeConfigurePS2DebugImpl()
command! -nargs=0 CMakeConfigurePS2Release call CMakeConfigurePS2ReleaseImpl()
command! -nargs=0 CMakeBuild call CMakeBuildImpl()
command! -nargs=0 CMakeBuildRunPS2Hardware call CMakeBuildRunPS2HardwareImpl()
command! -nargs=0 CMakeBuildRunPS2Emulator call CMakeBuildRunPS2EmulatorImpl()

" #Remaps

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
nnoremap <F6> :call CMakeBuildRunPS2HardwareImpl()<CR>
nnoremap <F7> :call CMakeBuildRunPS2EmulatorImpl()<CR>
nnoremap <F8> :!clear<CR>
nnoremap <F9> :call CMakeConfigurePS2DebugImpl()<CR>
nnoremap <F10> :GitAutoPush<CR>
nnoremap <C-J> :call LiveGrep()<CR>
nnoremap <C-K> :call FindFileProject()<CR>
nnoremap <C-L> :call FindFilePS2SDK()<CR>
nnoremap <S-Q> :call OpenRelativeFile()<CR>
nnoremap <S-W> :call OpenRelativeFileAnotherWindow()<CR>
nnoremap <S-E> :call NewFileAnotherWindow()<CR>
