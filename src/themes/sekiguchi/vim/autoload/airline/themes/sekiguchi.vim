let g:airline#themes#sekiguchi#palette = {}

function! airline#themes#sekiguchi#refresh()
  let s:N1 = [ '#0a1715' , '#0fa58f' , 16  , 37  ]
  let s:N2 = [ '#0a1715' , '#c6f3de' , 16  , 194 ]
  let s:N3 = [ '#50706a' , '#e5f8ec' , 59  , 194 ]
  let g:airline#themes#sekiguchi#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

  let s:I1 = [ '#f5fbf7' , '#5aa4ff' , 231 , 75  ]
  let s:I2 = [ '#0a1715' , '#c6f3de' , 16  , 194 ]
  let s:I3 = [ '#50706a' , '#e5f8ec' , 59  , 194 ]
  let g:airline#themes#sekiguchi#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)

  let s:V1 = [ '#0a1715' , '#b48722' , 16  , 136 ]
  let s:V2 = [ '#0a1715' , '#c6f3de' , 16  , 194 ]
  let s:V3 = [ '#50706a' , '#e5f8ec' , 59  , 194 ]
  let g:airline#themes#sekiguchi#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

  let s:R1 = [ '#f5fbf7' , '#bc3847' , 231 , 124 ]
  let s:R2 = [ '#0a1715' , '#f8e3e6' , 16  , 224 ]
  let s:R3 = [ '#50706a' , '#e5f8ec' , 59  , 194 ]
  let g:airline#themes#sekiguchi#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)

  let s:IA1 = [ '#50706a' , '#e5f8ec' , 59  , 194 ]
  let s:IA2 = [ '#50706a' , '#e5f8ec' , 59  , 194 ]
  let s:IA3 = [ '#50706a' , '#e5f8ec' , 59  , 194 ]
  let g:airline#themes#sekiguchi#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
endfunction

call airline#themes#sekiguchi#refresh()
