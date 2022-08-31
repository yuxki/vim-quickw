" ============================================================
" Filename: quickw.vim
" Author: yuxki
" License: MIT License
" Version: 1.1.1
" Last Change: 2022/08/30
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

  func! pkm.WordSpaces() dict
    let word_spaces = []
    let start = 0
    let keys_len = len(self.keys)
    for pos in self.positions
      if len(word_spaces) % keys_len == 0
        let start = 0
      endif

      let end = (pos[1] - 1) >= 0 ? (pos[1] - 1) : 0
      let space = (pos[1] - 1) >= 0 ? ' ' : ''
      let spaces = substitute(self.line[start:end], '[^\t]', space, 'g')
      call add(word_spaces, spaces)
      let start = pos[1] + 1
    endfor

    return word_spaces
  endfunc

  func! pkm.HorizOpts() dict
    let line_plus = len(self.pages) < 2 ? 1 : 2
    let wininfo = getwininfo(win_getid())[0]
    let options = #{
          \ filtermode: 'n',
          \ pos: 'botleft',
          \ line: 'cursor+' . line_plus,
          \ col: wininfo['textoff'] + wininfo['wincol'],
          \ }
    return options
  endfunc

  func! pkm.InitHoriz() dict
    "init
    let self.vertical = 0
    let self.ignorecase = 1
    let self.line = getline('.')
    let self.positions = s:WordPositions(self.line, g:quickw_word_pattern)
    let self.mode = self.MODE_NORMAL

    " init by global vars
    let self.color_normal = g:quickw_color_normal
    let self.color_visual = g:quickw_color_visual
    let self.keys = g:quickw_word_keys
    let self.max_cols_lines = len(g:quickw_word_keys)
    let self.header = g:quickw_cover_line ? self.line : ''

    call self.Load(self.WordSpaces())
  endfunc

  func! pkm.ToHorizontal(winid) dict
    call self.InitHoriz()
    call self.Refresh()
    call popup_move(a:winid, self.HorizOpts())
  endfunc

  func! pkm.VertOpts() dict
    let even_adj = 0

    if len(self.keys) % 2 == 0
      let even_adj -= 1
    endif

    let options = #{
          \ pos: 'botleft',
          \ line: 'cursor+'.string((len(self.keys) / 2) + even_adj),
          \ col: 'cursor',
          \ scrollbar: 1,
          \ }
    return options
  endfunc

  func! pkm.InitVert() dict
    let self.vertical = 1
    let self.ignorecase = 0
    let self.keys = g:quickw_line_keys
    let self.max_cols_lines = len(self.keys)
    let self.header = ''

    let lines = []
    for key in self.keys
      call add(lines, ' ')
    endfor
    call self.Load(lines)

    " not the popup to be force positioned center, when popup is over winline
    " winline  key
    "          a   :top half (keylen / 2) + 1 -> cut it and can be worked
    " 1        b   :cursor
    " 2        c   :bot half
    let top_capacity = winline() - ((len(self.keys) / 2) + 1)
    if top_capacity < 0
      let self.pages[0] = self.pages[0][top_capacity * -1:]
    endif
  endfunc

  func! pkm.ToVert(winid) dict
    let self.mode = self.MODE_NORMAL
    call setwinvar(a:winid, '&wincolor', self.color_normal)

    call self.InitVert()
    call self.Refresh()

    call popup_move(a:winid, self.VertOpts())
  endfunc

  " overrides
  func! pkm.OnOpen(winid) dict
    call setwinvar(a:winid, '&wincolor', self.color_normal)
    call win_execute(a:winid, 'setl tabstop='.matchstr(execute('set ts?'), '\d\+$'))
  endfunc

  func! pkm.OnFilter(winid, key) dict
    if a:key == ':'
      return -1
    elseif a:key ==# 'v' && !self.vertical
      if self.mode ==# self.MODE_VISUAl
        let self.mode = self.MODE_NORMAL
        call setwinvar(a:winid, '&wincolor', self.color_normal)
      else
        let self.mode = self.MODE_VISUAl
        call setwinvar(a:winid, '&wincolor', self.color_visual)
      endif
      return 1
    elseif a:key ==# 'l'
      call self.ToVert(a:winid)
      return 1
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
    if !self.vertical
      " horizontal
      if self.mode ==# self.MODE_VISUAl
        exe 'normal! v '
      endif

      let pos = self.endofword == 0 ?
            \ self.positions[a:index][1] + 1 : self.positions[a:index][2]
      call cursor('.', pos)
      call popup_close(a:winid)
    else
      " vertical
      " diff from current line + number the of current line
      let col = (((len(self.keys) / 2) * -1) + a:index) + line('.')

      if  col < 0
        return
      endif

      call cursor(col, '.')
      call self.ToHorizontal(a:winid)
    endif
  endfunc

  return pkm
endfunc

let s:pkm_id = ''
func! quickw#QuickWord()
  if !pkm#Exists(s:pkm_id)
    let s:qw_pkm = s:QuickWordPkm()
  endif

  call s:qw_pkm.InitHoriz()
  if len(s:qw_pkm.pages) > 0
    call s:qw_pkm.Open(s:qw_pkm.HorizOpts())
  else
    call s:qw_pkm.InitVert()
    call s:qw_pkm.Open(s:qw_pkm.VertOpts())
  endif

  let s:pkm_id = s:qw_pkm.pkm_id
endfunc

let &cpo = s:save_cpo
unlet s:save_cpo
