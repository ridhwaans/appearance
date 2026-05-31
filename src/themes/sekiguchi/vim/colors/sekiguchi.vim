hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "sekiguchi"
set background=light

hi Normal       guifg=#0a1715 guibg=#f5fbf7 ctermfg=16 ctermbg=231
hi CursorLine   guibg=#edfdf4 ctermbg=194
hi CursorLineNr guifg=#b48722 gui=bold ctermfg=136 cterm=bold
hi LineNr       guifg=#6d8f89 ctermfg=66
hi Visual       guibg=#c6f3de ctermbg=194
hi Search       guifg=#0a1715 guibg=#d4f9e7 ctermfg=16 ctermbg=194
hi IncSearch    guifg=#f5fbf7 guibg=#0fa58f gui=bold ctermfg=231 ctermbg=37 cterm=bold
hi MatchParen   guifg=#d6764b gui=bold ctermfg=173 cterm=bold
hi ColorColumn  guibg=#e5f8ec ctermbg=194
hi Pmenu        guifg=#0a1715 guibg=#e5f8ec ctermfg=16 ctermbg=194
hi PmenuSel     guifg=#0a1715 guibg=#bdf1d8 ctermfg=16 ctermbg=157
hi StatusLine   guifg=#0a1715 guibg=#e5f8ec ctermfg=16 ctermbg=194
hi StatusLineNC guifg=#6d8f89 guibg=#e5f8ec ctermfg=66 ctermbg=194
hi VertSplit    guifg=#9fd9c1 guibg=#e5f8ec ctermfg=151 ctermbg=194
hi Comment      guifg=#6d8f89 gui=italic ctermfg=66 cterm=italic
hi Constant     guifg=#d6764b ctermfg=173
hi String       guifg=#16b67b ctermfg=35
hi Character    guifg=#16b67b ctermfg=35
hi Number       guifg=#d6764b ctermfg=173
hi Boolean      guifg=#bc3847 ctermfg=124
hi Float        guifg=#d6764b ctermfg=173
hi Identifier   guifg=#0a1715 ctermfg=16
hi Function     guifg=#0fa58f ctermfg=37
hi Statement    guifg=#5aa4ff ctermfg=75
hi Conditional  guifg=#5aa4ff ctermfg=75
hi Repeat       guifg=#5aa4ff ctermfg=75
hi Operator     guifg=#0fa58f ctermfg=37
hi Keyword      guifg=#5aa4ff ctermfg=75
hi Exception    guifg=#bc3847 ctermfg=124
hi PreProc      guifg=#b48722 ctermfg=136
hi Include      guifg=#5aa4ff ctermfg=75
hi Define       guifg=#5aa4ff ctermfg=75
hi Type         guifg=#b48722 ctermfg=136
hi Special      guifg=#a897e8 ctermfg=141
hi Delimiter    guifg=#50706a ctermfg=59
hi Underlined   guifg=#0fa58f gui=underline ctermfg=37 cterm=underline
hi Error        guifg=#bc3847 gui=bold ctermfg=124 cterm=bold
hi Todo         guifg=#b48722 gui=bold ctermfg=136 cterm=bold
hi DiagnosticError guifg=#bc3847 ctermfg=124
hi DiagnosticWarn  guifg=#b48722 ctermfg=136
hi DiagnosticInfo  guifg=#5aa4ff ctermfg=75
hi DiagnosticHint  guifg=#0fa58f ctermfg=37
