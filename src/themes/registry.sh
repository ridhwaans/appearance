#!/usr/bin/env bash

load_theme_registry() {
  theme=$1

  VIMPLUG_COLORSCHEME=""
  VIM_LOCAL_RUNTIME_DIR=""
  VSCODE_EXTENSION_PATH=""
  VSCODE_ICON_EXTENSION=""
  VSCODE_ICON_THEME="material-icon-theme"
  VSCODE_COLOR_EXTENSION=""
  VSCODE_COLOR_THEME=""

  case "$theme" in
    gotham)
      WT_COLOR_SCHEME="Gotham"
      TERM_FILENAME="Gotham.terminal"
      VSCODE_ICON_EXTENSION="PKief.material-icon-theme"
      VSCODE_COLOR_EXTENSION="alireza94.theme-gotham"
      VSCODE_COLOR_THEME="Gotham"
      VIMPLUG_COLORSCHEME="whatyouhide/vim-gotham"
      VIM_COLORSCHEME="gotham"
      NVIM_COLORSCHEME="neogotham"
      ;;
    sekiguchi)
      WT_COLOR_SCHEME="Sekiguchi"
      TERM_FILENAME="Sekiguchi.terminal"
      VSCODE_EXTENSION_PATH=$APPEARANCE_DIR/src/themes/$theme/vscode
      VSCODE_COLOR_THEME="Sekiguchi"
      VIM_COLORSCHEME="sekiguchi"
      VIM_LOCAL_RUNTIME_DIR=$APPEARANCE_DIR/src/themes/$theme/vim
      NVIM_COLORSCHEME="sekiguchi"
      ;;
    *)
      echo "Error: Unknown theme '$theme'."
      exit 1
      ;;
  esac
}

export -f load_theme_registry
