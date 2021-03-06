if exists("g:loaded_vim_simple_complete")
  finish
endif
let g:loaded_vim_simple_complete = 1

let g:vsc_tab_complete = get(g:, 'vsc_tab_complete', 1)
let g:vsc_completion_command = get(g:, 'vsc_completion_command', "\<C-P>")
let g:vsc_reverse_completion_command = get(g:, 'vsc_reverse_completion_command', "\<C-N>")

fun! Init()
    call TypeCompletePlugin()

    if g:vsc_tab_complete
        call TabCompletePlugin()
    endif
endfun

fun! TabCompletePlugin()
    inoremap <expr> <Tab> TabComplete(0)
    inoremap <expr> <S-Tab> TabComplete(1)

    fun! TabComplete(reverse)
        if getline('.')[col('.') - 2] =~ '\K' || pumvisible()
            return a:reverse == 1 ? g:vsc_reverse_completion_command : g:vsc_completion_command
        else
            return "\<Tab>"
        endif
    endfun
endfun

fun! TypeCompletePlugin()
    set completeopt=menu,menuone,noinsert,preview
    imap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
    autocmd InsertCharPre * call TypeComplete()

    fun! TypeComplete()
        if v:char =~ '\K'
            \ && getline('.')[col('.') - 4] !~ '\K'
            \ && getline('.')[col('.') - 3] =~ '\K'
            \ && getline('.')[col('.') - 2] =~ '\K' " last typed char
            \ && getline('.')[col('.') - 1] !~ '\K'

            call feedkeys(g:vsc_completion_command, 'n')
        end
    endfun
endfun

call Init()
