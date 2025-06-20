" Later on maybe 256 colors terminal mode will be implemented, or maybe not!
if !has('gui_running') && &t_Co < 256
    finish
endif

set termguicolors
set background=dark

hi clear
if exists('syntax_on')
    syntax reset
endif

let g:colors_name = 'zx'

let s:fg0light  = { "gui": "#4C5648" } " Normal text a little lighter
let s:fg0       = { "gui": "#D1B897" } " Normal text
let s:fg1       = { "gui": "#E1E1E1" } " White text
let s:fg2       = { "gui": "#8DEEB4" } " Green for types
let s:bg0       = { "gui": "#062329" } " Background #062329
let s:select    = { "gui": "#115F6F" } " Visual mode selection
let s:comment   = { "gui": "#44C340" } " Comments
let s:string    = { "gui": "#2EC09C" } " Strings
let s:number    = { "gui": "#7AD0C6" } " Numbers
let s:menuBg    = { "gui": "#3A3A3A" } " Popup menu background
let s:menuIBg   = { "gui": "#2D2D2D" } " Popup menu selected item background
let s:functions = { "gui": "#FFFFFF" } " Functions
let s:macros    = { "gui": "#8CDE94" } " Preprocessor Macros
let s:types     = { "gui": "#7AD0C6" } " Types
let s:curLine   = { "gui": "#163339" } " Current line at the cursor 
let s:dark      = { "gui": "#000000" } " Transparent 
let s:slbg0     = { "gui": "#0B414B" } " Status line (mode) background 
let s:slbg1     = { "gui": "#0F5966" } " Status line (file) background

function! s:h(group, style)
   execute "hi!" a:group
        \ "guifg=" (has_key(a:style, "fg")  ? a:style.fg.gui : "NONE") 
        \ "guibg=" (has_key(a:style, "bg")  ? a:style.bg.gui : "NONE")
        \ "guisp=" (has_key(a:style, "sp")  ? a:style.sp.gui : "NONE")
        \ "gui="   (has_key(a:style, "gui") ? a:style.gui    : "NONE")
endfunction

" Default GUI

call s:h("Normal",         { "fg": s:fg0, "bg": s:bg0 })
call s:h("EndOfBuffer",    { "fg": s:fg0, "bg": s:bg0 })
call s:h("Visual",         { "bg": s:select })
call s:h("Comment",        { "fg": s:comment })
call s:h("String",         { "fg": s:string })
call s:h("Number",         { "fg": s:number })
call s:h("Macro",          { "fg": s:macros })
call s:h("Constant",       { "fg": s:types })
call s:h("Include",        { "fg": s:macros })
call s:h("Identifier",     { "fg": s:fg1 })
call s:h("PreProc",        { "fg": s:macros })
call s:h("Define",         { "fg": s:macros })
call s:h("PreCondit",      { "fg": s:fg1 })
call s:h("Keyword",        { "fg": s:fg1 })
call s:h("Structure",      { "fg": s:fg2 })
call s:h("Typedef",        { "fg": s:fg2 })
call s:h("Type",           { "fg": s:macros })
call s:h("Label",          { "fg": s:fg1 })
call s:h("Boolean",        { "fg": s:number })
call s:h("StorageClass",   { "fg": s:fg1 })
call s:h("Special",        { "fg": s:fg1 })
call s:h("Character",      { "fg": s:string })
call s:h("SpecialComment", { "fg": s:fg1 })
call s:h("Statement",      { "fg": s:fg1 })
call s:h("Conditional",    { "fg": s:fg1 })
call s:h("Todo",           { "fg": s:fg1, "bg": s:bg0 })
call s:h("vimFunction",    { "fg": s:fg0, "bg": s:bg0 })
call s:h("vimUserCmdError",{ "fg": s:fg0, "bg": s:bg0 })

" Misc.

call s:h("CursorLine",     { "bg": s:curLine })
call s:h("LineNr",         { "fg": s:fg0light })
call s:h("CursorLineNr",   { "fg": s:fg0 })
call s:h("WildMenu",       { "bg": s:slbg0, "fg": s:fg1 })
call s:h("StatusLine",     { "fg": s:slbg1, "bg": s:fg1 })
call s:h("StatusLineNC",   { "fg": s:slbg1, "bg": s:bg0 })
call s:h("User2",          { "bg": s:slbg0, "fg": s:fg1 })
call s:h("User1",          { "bg": s:slbg1, "fg": s:fg1 })

" Fix cursor line
hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white
hi CursorLineNr cterm=NONE ctermbg=darkred ctermfg=white

" Fix split background
hi VertSplit    cterm=NONE
