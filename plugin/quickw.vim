if exists('g:loaded_quickw')
  finish
elseif v:version < 802
  echoerr "This plugin needs Vim 8.2+ functions"
endif
let g:loaded_switch_name = 1

let s:save_cpo = &cpo
set cpo&vim

hi QuickWord term=reverse ctermbg=16 guibg=#000000
hi QuickWordV term=reverse ctermfg=215 guifg=#ffb964 ctermbg=16 guibg=#000000

if !exists('g:quickw_word_pattern')
  let g:quickw_word_pattern = '\k\+'
endif

if !exists('g:quickw_keys')
  let g:quickw_keys = 'abcdefgijkmnopqrstuwyz'
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
