if exists('g:loaded_quickw')
  finish
elseif v:version < 802
  echoerr "This plugin needs Vim 8.2+ functions"
endif
let g:loaded_switch_name = 1

let s:save_cpo = &cpo
set cpo&vim

hi QuickWord ctermfg=231 ctermbg=240 guifg=#ffffff guibg=#606060
hi QuickWordV ctermfg=215 ctermbg=240 guifg=#ffb964 guibg=#606060

if !exists('g:quickw_word_pattern')
  let g:quickw_word_pattern = '\k\+'
endif

if !exists('g:quickw_word_keys')
  let g:quickw_word_keys = 'abcdefgijkmnopqrstuwyz'
endif

if !exists('g:quickw_line_keys')
  " long 'ABCDEFGIJKMabcdefgijkmnopqrstuwyzNOPQRSTUWYZ'
  let g:quickw_line_keys = 'abcdefgijkmnopqrstuwyz'
endif

if !exists('g:quickw_color_normal')
  let g:quickw_color_normal = 'QuickWord'
endif

if !exists('g:quickw_color_visual')
  let g:quickw_color_visual = 'QuickWordV'
endif

if !exists('g:quickw_cover_line')
  let g:quickw_cover_line = 0
endif

nmap <silent> W :call quickw#QuickWord()<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
