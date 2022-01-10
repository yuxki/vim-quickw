# Quick w
## Contents
 - [Introduction](#introduction)
 - [Usage](#usage)
 - [Installation](#installation)
 - [Options](#options)

## Introduction

The "Quick w" postions the cursor at the word in the line quickly.

![Demo1](assets/intro_demo.gif?raw=true)

## Usage

### Move Around
Run ```Quickw``` to display the popup that guides the word positions.
```
:Quickw
```

#### Word
Select the key on the popup, the cursor will be positioned to head of the word.

![Demo2](assets/usage_word_demo.gif?raw=true)

#### Line
The 'l' key changes to the line selection mode, and displays the line guide popup on the cursor colum.
Select the key on the popup, the cursor will be positioned the line, and the word guide popup will be displayed.

![Demo3](assets/usage_line_demo.gif?raw=true)
- - - -
### Close Popup
The 'x' key closes the popup.
- - - -
### Select Range
The guide key after the 'v' key input, selects from the cursor to the word in visual mode. This works in the line only.

![Demo4](assets/usage_sel_demo.gif?raw=true)
- - - -
### Use Quickly
To use quickly, map calling ```quickw#QuickWord()``` to a key.

For example,  you can add this script to the ".vimrc":
```
" replace key
nmap <silent> key :Quickw<CR>
```
## Installation
vim-quickw requires https://github.com/yuxki/vim-pkm-api.

With vim-plug:
```
Plug 'yuxki/vim-pkm-api'
Plug 'yuxki/vim-quickw'
```

## Options
### g:quickw_word_pattern
The pattern that is used to match the words.

Default:
```
let g:quickw_word_pattern = '\k\+'
```
Example to mark the brackets:
```
let g:quickw_word_pattern = '\k\+\|[(){}\[\]]'
```
Example to mark the math operators:
```
let g:quickw_word_pattern = '\k\+\|[-+=%\/]'
```
- - - -
### g:quickw_word_keys
The guide keys that is mapped to the words.The lowercase letters (a-z) are supported.

Default:
```
let g:quickw_word_keys = 'abcdefgijkmnopqrstuwyz'
```
The following keys are reseved.

|Key|Description|
|---|---|
|v|Toggle between the positioning and the range selection.|
|l|Use the line guide. The 'L' key mapped the key to move to next page.|
|h|The 'H' key mapped the key to move to previous page.|
|x|Close the popup.|
|:|Use Vim command-line mode.|
- - - -
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

|Key|Description|
|---|---|
|:|Use Vim command-line mode.|
|x|Close the popup.|
- - - -
### g:quickw_color_normal
The main popup color.

Default:
```
hi QuickWord ctermfg=231 ctermbg=240 guifg=#ffffff guibg=#606060
let g:quickw_color_normal = 'QuickWord'
```
Example to use dark theme:
```
hi MyQuickWord ctermbg=16 guibg=#000000
let g:quickw_color_normal = 'MyQuickWord'
```
- - - -
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
- - - -
### g:quickw_cover_line
When TRUE, the marked line will be coverd by the popup that displays the line.

Default:
```
let g:quickw_cover_line = 0
```
This option could be useful, when the guide popup is out of alignment, due to Vim environment. And when there is invisible charactor, like '*', '|' in vim help.
- - - -
### g:loaded_quickw
To prevent from loading this plugin, add following script to the ".vimrc":
```
let g:loaded_quickw = 1
```
