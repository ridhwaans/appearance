#!/bin/sh
# Sekiguchi - Shell color setup script

if [ "${TERM%%-*}" = 'linux' ]; then
    return 2>/dev/null || exit 0
fi

color00="f5/fb/f7"
color01="bc/38/47"
color02="16/b6/7b"
color03="b4/87/22"
color04="5a/a4/ff"
color05="a8/97/e8"
color06="0f/a5/8f"
color07="0a/17/15"
color08="6d/8f/89"
color09="d6/76/4b"
color10="7d/e2/b6"
color11="cf/b2/59"
color12="90/c2/ff"
color13="c9/bf/f3"
color14="6f/d6/c7"
color15="e5/f8/ec"
color_foreground="0a/17/15"
color_background="f5/fb/f7"
color_cursor="0f/a5/8f"

if [ -n "$TMUX" ]; then
  printf_template="\033Ptmux;\033\033]4;%d;rgb:%s\007\033\\"
  printf_template_var="\033Ptmux;\033\033]%d;rgb:%s\007\033\\"
  printf_template_custom="\033Ptmux;\033\033]%s%s\007\033\\"
elif [ "${TERM%%-*}" = "screen" ]; then
  printf_template="\033P\033]4;%d;rgb:%s\007\033\\"
  printf_template_var="\033P\033]%d;rgb:%s\007\033\\"
  printf_template_custom="\033P\033]%s%s\007\033\\"
else
  printf_template="\033]4;%d;rgb:%s\033\\"
  printf_template_var="\033]%d;rgb:%s\033\\"
  printf_template_custom="\033]%s%s\033\\"
fi

printf $printf_template 0  $color00
printf $printf_template 1  $color01
printf $printf_template 2  $color02
printf $printf_template 3  $color03
printf $printf_template 4  $color04
printf $printf_template 5  $color05
printf $printf_template 6  $color06
printf $printf_template 7  $color07
printf $printf_template 8  $color08
printf $printf_template 9  $color09
printf $printf_template 10 $color10
printf $printf_template 11 $color11
printf $printf_template 12 $color12
printf $printf_template 13 $color13
printf $printf_template 14 $color14
printf $printf_template 15 $color15

if [ -n "$ITERM_SESSION_ID" ]; then
  printf $printf_template_custom Pg 0a1715
  printf $printf_template_custom Ph f5fbf7
  printf $printf_template_custom Pi 0a1715
  printf $printf_template_custom Pj c6f3de
  printf $printf_template_custom Pk 0a1715
  printf $printf_template_custom Pl 0fa58f
  printf $printf_template_custom Pm f5fbf7
else
  printf $printf_template_var 10 $color_foreground
  printf $printf_template_var 11 $color_background
  printf $printf_template_var 12 $color_cursor
fi

unset printf_template printf_template_var printf_template_custom
unset color00 color01 color02 color03 color04 color05 color06 color07
unset color08 color09 color10 color11 color12 color13 color14 color15
unset color_foreground color_background color_cursor
