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
