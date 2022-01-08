## Introduction

The "Quick w" postions the cursor at the word in the line quickly.

![Demo1](assets/intro_demo.gif?raw=true)

## Usage

### Move Around
Call quickw#QuickWord() to display the popup that guides the word positions.
```
:call quickw#QuickWord()
```
![Demo2](assets/usage_word_demo.gif?raw=true)

Select the key on the popup, the cursor will be positioned to head of the word.

![Demo3](assets/usage_line_demo.gif?raw=true)

The 'l' key changes to the line selection mode, and displays the line guide popup on the cursor colum.
Select the key on the popup, the cursor will be positioned the line, and the word guide popup will be displayed.

### Close Popup
The 'x' key closes the popup.

### Select Range
![Demo3](assets/usage_sel_demo.gif?raw=true)

The guide key after the 'v' key input, selects from the cursor to the word in visual mode. This works in the line only.

## Installation
vim-quickw requires https://github.com/yuxki/vim-pkm-api.

With vim-plug:
```
Plug 'yuxki/vim-pkm-api'
Plug 'yuxki/vim-quickw'
```

## Options
### g:quickw_word_pattern
The words are mapped to the keys when matched this pattern.

Default:
```
let g:quickw_word_pattern = '\k\+'
```
Example to mark the math operators:
```
let g:quickw_word_pattern = '[0-9a-zA-Z-_=+]\+'
```
### g:quickw_word_keys
The guide keys that is mapped to the words.The lowercase letters (a-z) are supported.

Default:
```
let g:quickw_word_keys = 'abcdefgijkmnopqrstuwyz'
```
The following keys are reseved.

|The key|Description|
|---|---|
|'v'|Toggle between the positioning and the range selection.|
|'l'|Use the line guide. The 'L' key mapped the key to move to next page.|
|'h'|The 'H' key mapped the key to move to previous page.|
|'x'|Close the popup.|
|':'|Use Vim command-line mode.|

### g:quickw_line_keys
The guide keys that is mapped to the lines. The charactors that are determined as the single charactor (e.g. a-z, A-z, 0-9, [, {) are supported.

Default:
```
let g:quickw_line_keys = 'abcdefgijkmnopqrstuwyz'
```
Example to extend range of the guide:
```
let g:quickw_line_keys = 'ABCDEFGIJKMabcdefgijkmnopqrstuwyzNOPQRSTUWYZ'
```
The following keys are reseved.

|The key|Description|
|---|---|
|':'|Use Vim command-line mode.|
|'x'|Close the popup.|
### g:quickw_color_normal
The main popup color.

Default:
```
hi QuickWord ctermfg=231 ctermbg=240 guifg=#ffffff guibg=#606060
let g:quickw_color_normal = 'QuickWord' " same as "Pmenu"
```
Example to use dark theme:
```
hi MyQuickWord ctermbg=16 guibg=#000000
let g:quickw_color_normal = 'MyQuickWord'
```
### g:quickw_color_visual
The popup color when selecting range in visual mode.

Default:
```
hi QuickWordV ctermfg=215 ctermbg=240 guifg=#ffb964 guibg=#606060
let g:quickw_color_visual = 'QuickWordV'
```
Example to use dark theme:
```
hi MyQuickWordV ctermfg=215 ctermbg=16 guifg=#ffb964 guibg=#000000
let g:quickw_color_visual = 'MyQuickWordV'
```
### g:quickw_cover_line
When TRUE, the marked line will be coverd by the popup that displays the line.

Default:
```
let g:quickw_cover_line = 0
```
This option could be useful, when the guide popup is out of alignment, due to Vim environment. And when there is invisible charactor, like '*', '|' in vim help.
