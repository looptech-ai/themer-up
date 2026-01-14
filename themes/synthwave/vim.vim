" Synthwave Theme for Vim/Neovim
" Place in ~/.vim/colors/synthwave.vim or ~/.config/nvim/colors/synthwave.vim

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "synthwave"

" ============================================================================
" Terminal Colors
" ============================================================================
let g:terminal_ansi_colors = [
  \ '#21222c', '#ff5555', '#50fa7b', '#f1fa8c',
  \ '#bd93f9', '#ff79c6', '#8be9fd', '#f8f8f2',
  \ '#6272a4', '#ff6e6e', '#69ff94', '#ffffa5',
  \ '#d6acff', '#ff92df', '#a4ffff', '#ffffff'
  \ ]

" Neovim terminal colors
if has('nvim')
  let g:terminal_color_0  = '#21222c'
  let g:terminal_color_1  = '#ff5555'
  let g:terminal_color_2  = '#50fa7b'
  let g:terminal_color_3  = '#f1fa8c'
  let g:terminal_color_4  = '#bd93f9'
  let g:terminal_color_5  = '#ff79c6'
  let g:terminal_color_6  = '#8be9fd'
  let g:terminal_color_7  = '#f8f8f2'
  let g:terminal_color_8  = '#6272a4'
  let g:terminal_color_9  = '#ff6e6e'
  let g:terminal_color_10 = '#69ff94'
  let g:terminal_color_11 = '#ffffa5'
  let g:terminal_color_12 = '#d6acff'
  let g:terminal_color_13 = '#ff92df'
  let g:terminal_color_14 = '#a4ffff'
  let g:terminal_color_15 = '#ffffff'
endif

" ============================================================================
" Highlight Groups
" ============================================================================

" Editor
hi Normal          guifg=#eaeaea guibg=#1a1a2e gui=NONE
hi NormalFloat     guifg=#eaeaea guibg=#16162a gui=NONE
hi Cursor          guifg=#1a1a2e guibg=#ff79c6 gui=NONE
hi CursorLine      guifg=NONE    guibg=#21222c gui=NONE
hi CursorLineNr    guifg=#ff79c6 guibg=NONE    gui=bold
hi LineNr          guifg=#6272a4 guibg=NONE    gui=NONE
hi SignColumn      guifg=NONE    guibg=#1a1a2e gui=NONE
hi ColorColumn     guifg=NONE    guibg=#21222c gui=NONE
hi VertSplit       guifg=#44475a guibg=#1a1a2e gui=NONE
hi StatusLine      guifg=#eaeaea guibg=#21222c gui=NONE
hi StatusLineNC    guifg=#6272a4 guibg=#16162a gui=NONE

" Selection
hi Visual          guifg=NONE    guibg=#44475a gui=NONE
hi VisualNOS       guifg=NONE    guibg=#44475a gui=NONE
hi Search          guifg=#1a1a2e guibg=#f1fa8c gui=NONE
hi IncSearch       guifg=#1a1a2e guibg=#ff79c6 gui=NONE

" Popup Menu
hi Pmenu           guifg=#eaeaea guibg=#21222c gui=NONE
hi PmenuSel        guifg=#1a1a2e guibg=#ff79c6 gui=NONE
hi PmenuSbar       guifg=NONE    guibg=#44475a gui=NONE
hi PmenuThumb      guifg=NONE    guibg=#6272a4 gui=NONE

" Tabs
hi TabLine         guifg=#6272a4 guibg=#16162a gui=NONE
hi TabLineFill     guifg=NONE    guibg=#16162a gui=NONE
hi TabLineSel      guifg=#ff79c6 guibg=#1a1a2e gui=bold

" Folding
hi Folded          guifg=#6272a4 guibg=#21222c gui=NONE
hi FoldColumn      guifg=#6272a4 guibg=#1a1a2e gui=NONE

" Diff
hi DiffAdd         guifg=#50fa7b guibg=#1a1a2e gui=NONE
hi DiffChange      guifg=#f1fa8c guibg=#1a1a2e gui=NONE
hi DiffDelete      guifg=#ff5555 guibg=#1a1a2e gui=NONE
hi DiffText        guifg=#1a1a2e guibg=#f1fa8c gui=NONE

" Messages
hi ErrorMsg        guifg=#ff5555 guibg=NONE    gui=bold
hi WarningMsg      guifg=#f1fa8c guibg=NONE    gui=bold
hi MoreMsg         guifg=#50fa7b guibg=NONE    gui=NONE
hi Question        guifg=#8be9fd guibg=NONE    gui=NONE
hi ModeMsg         guifg=#ff79c6 guibg=NONE    gui=bold

" Misc
hi Directory       guifg=#bd93f9 guibg=NONE    gui=NONE
hi MatchParen      guifg=#1a1a2e guibg=#ff79c6 gui=bold
hi NonText         guifg=#44475a guibg=NONE    gui=NONE
hi SpecialKey      guifg=#44475a guibg=NONE    gui=NONE
hi Title           guifg=#ff79c6 guibg=NONE    gui=bold
hi WildMenu        guifg=#1a1a2e guibg=#ff79c6 gui=NONE

" ============================================================================
" Syntax Highlighting
" ============================================================================

hi Comment         guifg=#6272a4 guibg=NONE    gui=italic

hi Constant        guifg=#bd93f9 guibg=NONE    gui=NONE
hi String          guifg=#f1fa8c guibg=NONE    gui=NONE
hi Character       guifg=#f1fa8c guibg=NONE    gui=NONE
hi Number          guifg=#bd93f9 guibg=NONE    gui=NONE
hi Boolean         guifg=#bd93f9 guibg=NONE    gui=NONE
hi Float           guifg=#bd93f9 guibg=NONE    gui=NONE

hi Identifier      guifg=#8be9fd guibg=NONE    gui=NONE
hi Function        guifg=#50fa7b guibg=NONE    gui=NONE

hi Statement       guifg=#ff79c6 guibg=NONE    gui=NONE
hi Conditional     guifg=#ff79c6 guibg=NONE    gui=NONE
hi Repeat          guifg=#ff79c6 guibg=NONE    gui=NONE
hi Label           guifg=#ff79c6 guibg=NONE    gui=NONE
hi Operator        guifg=#ff79c6 guibg=NONE    gui=NONE
hi Keyword         guifg=#ff79c6 guibg=NONE    gui=NONE
hi Exception       guifg=#ff79c6 guibg=NONE    gui=NONE

hi PreProc         guifg=#ff79c6 guibg=NONE    gui=NONE
hi Include         guifg=#ff79c6 guibg=NONE    gui=NONE
hi Define          guifg=#ff79c6 guibg=NONE    gui=NONE
hi Macro           guifg=#ff79c6 guibg=NONE    gui=NONE
hi PreCondit       guifg=#ff79c6 guibg=NONE    gui=NONE

hi Type            guifg=#8be9fd guibg=NONE    gui=NONE
hi StorageClass    guifg=#ff79c6 guibg=NONE    gui=NONE
hi Structure       guifg=#8be9fd guibg=NONE    gui=NONE
hi Typedef         guifg=#8be9fd guibg=NONE    gui=NONE

hi Special         guifg=#ff79c6 guibg=NONE    gui=NONE
hi SpecialChar     guifg=#ff79c6 guibg=NONE    gui=NONE
hi Tag             guifg=#ff79c6 guibg=NONE    gui=NONE
hi Delimiter       guifg=#eaeaea guibg=NONE    gui=NONE
hi SpecialComment  guifg=#6272a4 guibg=NONE    gui=italic
hi Debug           guifg=#ff79c6 guibg=NONE    gui=NONE

hi Underlined      guifg=#8be9fd guibg=NONE    gui=underline
hi Error           guifg=#ff5555 guibg=NONE    gui=bold
hi Todo            guifg=#f1fa8c guibg=NONE    gui=bold,italic

" ============================================================================
" Plugin Support
" ============================================================================

" GitGutter
hi GitGutterAdd    guifg=#50fa7b guibg=NONE    gui=NONE
hi GitGutterChange guifg=#f1fa8c guibg=NONE    gui=NONE
hi GitGutterDelete guifg=#ff5555 guibg=NONE    gui=NONE

" NERDTree
hi NERDTreeDir     guifg=#bd93f9 guibg=NONE    gui=NONE
hi NERDTreeFile    guifg=#eaeaea guibg=NONE    gui=NONE
hi NERDTreeExecFile guifg=#50fa7b guibg=NONE   gui=NONE

" Telescope (Neovim)
hi TelescopeNormal guifg=#eaeaea guibg=#1a1a2e gui=NONE
hi TelescopeBorder guifg=#bd93f9 guibg=#1a1a2e gui=NONE
hi TelescopePromptPrefix guifg=#ff79c6 guibg=NONE gui=NONE
hi TelescopeSelection guifg=#ff79c6 guibg=#21222c gui=NONE

" LSP
hi DiagnosticError guifg=#ff5555 guibg=NONE    gui=NONE
hi DiagnosticWarn  guifg=#f1fa8c guibg=NONE    gui=NONE
hi DiagnosticInfo  guifg=#8be9fd guibg=NONE    gui=NONE
hi DiagnosticHint  guifg=#bd93f9 guibg=NONE    gui=NONE

" TreeSitter
hi @variable       guifg=#eaeaea guibg=NONE    gui=NONE
hi @function       guifg=#50fa7b guibg=NONE    gui=NONE
hi @function.call  guifg=#50fa7b guibg=NONE    gui=NONE
hi @keyword        guifg=#ff79c6 guibg=NONE    gui=NONE
hi @string         guifg=#f1fa8c guibg=NONE    gui=NONE
hi @type           guifg=#8be9fd guibg=NONE    gui=NONE
hi @constant       guifg=#bd93f9 guibg=NONE    gui=NONE
hi @comment        guifg=#6272a4 guibg=NONE    gui=italic
