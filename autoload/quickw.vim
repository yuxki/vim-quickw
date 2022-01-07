" ============================================================
" Filename: quickw.vim
" Author: yuxki
" License: MIT License
" Last Change: 2022/01/07
" ============================================================

let s:save_cpo = &cpo
set cpo&vim

func! s:WordPositions(line, pat)
  let start = 0
  let positions = []

  while 1
    let pos = matchstrpos(a:line, a:pat, start)
    if pos[2] < 0
      break
    endif
    call add(positions, pos)
    let start = pos[2]
  endwhile
  return positions
endfunc

func! s:QuickWordPkm()
  let pkm = pkm#PopupKeyMenu()

  let pkm.max_cols_lines = len(pkm.keys)
  let pkm.key_guide = "%t%k"
  let pkm.ignorecase = 1
  let pkm.align = 0
  let pkm.item_border = ""
  let pkm.page_guides = ["%n>", "<%v %n>", "<%v"]

  " extends
  let pkm.MODE_NORMAL = 'n'
  let pkm.MODE_VISUAl = 'v'

  let pkm.mode = pkm.MODE_NORMAL
  let pkm.endofword = 0
  let pkm.line = ''
  let pkm.positions = []
  let pkm.color_normal = 'Pmenu'
  let pkm.color_visual = 'PmenuSel'

  func! pkm.WordSpaces()
    let word_spaces = []
    let start = 0
    let keys_len = len(self.keys)
    for pos in self.positions
      if len(word_spaces) % keys_len == 0
        let start = 0
      endif

      let end = (pos[1] - 1) >= 0 ? (pos[1] - 1) : 0
      let space = end > 0 ? ' ' : ''
      let spaces = substitute(self.line[start:end], '[^\t]', space, 'g')
      call add(word_spaces, spaces)
      let start = pos[1] + 1
    endfor

    return word_spaces
  endfunc

  " overrides
  func! pkm.OnOpen(winid)
    call setwinvar(a:winid, '&wincolor', self.color_normal)
  endfunc

  func! pkm.OnFilter(winid, key) dict
    if a:key == ':'
      return -1
    elseif a:key ==# 'v'
      if self.mode ==# self.MODE_VISUAl
        let self.mode = self.MODE_NORMAL
        call setwinvar(a:winid, '&wincolor', self.color_normal)
      else
        let self.mode = self.MODE_VISUAl
        call setwinvar(a:winid, '&wincolor', self.color_visual)
      endif
    endif

    if len(a:key) == 1
      if a:key =~# '\u'
        let self.endofword = 1
      else
        let self.endofword = 0
      endif
    endif
  endfunc

  func! pkm.OnKeySelect(winid, index) dict
    if self.mode ==# self.MODE_VISUAl
      exe 'normal! v '
    endif

    let pos = self.endofword == 0 ?
          \ self.positions[a:index][1] + 1 : self.positions[a:index][2]
    call cursor('.', pos)
    call popup_close(a:winid)
  endfunc
  return pkm
endfunc

let s:pkm_id = ''
func! quickw#QuickWord()
  if !pkm#Exists(s:pkm_id)
    let s:qw_pkm = s:QuickWordPkm()
  endif

  " init
  let s:qw_pkm.line = getline('.')
  let s:qw_pkm.positions = s:WordPositions(s:qw_pkm.line, g:quickw_word_pattern)
  let s:qw_pkm.mode = s:qw_pkm.MODE_NORMAL

  " init by global vars
  let s:qw_pkm.color_normal = g:quickw_color_normal
  let s:qw_pkm.color_visual = g:quickw_color_visual
  let s:qw_pkm.keys = g:quickw_keys
  let s:qw_pkm.max_cols_lines = len(g:quickw_keys)
  let s:qw_pkm.header = g:quickw_cover_line ? s:qw_pkm.line : ''

  call s:qw_pkm.Load(s:qw_pkm.WordSpaces())

  let line_plus = len(s:qw_pkm.pages) < 2 ? 1 : 2
  let options = #{
        \ filtermode: 'n',
        \ pos: 'botleft',
        \ line: 'cursor+' . line_plus,
        \ col: 'cursor-' . (virtcol('.') - 1) ,
        \ }
  call s:qw_pkm.Open(options)

  let s:pkm_id = s:qw_pkm.pkm_id
endfunc

let &cpo = s:save_cpo
unlet s:save_cpo
