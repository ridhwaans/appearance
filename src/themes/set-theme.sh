#!/usr/bin/env bash

set -e

conditional_sed() {
    # use gnu sed for no explicit backup in-place editing on mac
    if [ $(uname) = Darwin ]; then
        gsed "$@"
    else
        sed "$@"
    fi
}

install_vscode_extension_path() {
  local extension_path=$1
  local extension_name=$(jq -r '.name' "$extension_path/package.json")
  local extension_publisher=$(jq -r '.publisher' "$extension_path/package.json")
  local extension_version=$(jq -r '.version' "$extension_path/package.json")
  local extension_dir=$VSCODE_EXTENSIONS_DIR/$extension_publisher.$extension_name-$extension_version

  rm -rf "$extension_dir"
  mkdir -p "$extension_dir"
  cp -R "$extension_path"/. "$extension_dir"
}

set_theme() {
  theme=$1
  NVIM_LOCAL_PLUGIN_DIR=""
  VIM_LOCAL_RUNTIME_DIR=""
  VSCODE_EXTENSION_PATH=""
  VSCODE_ICON_EXTENSION=""
  VSCODE_ICON_THEME=""
  VSCODE_COLOR_EXTENSION=""
  VSCODE_COLOR_THEME=""
  case "$theme" in
    gotham)
      # nvim
      NVIM_FILENAME="colorscheme.lua"
      NVIM_COLORSCHEME="neogotham"

      # Windows Terminal
      WT_FILENAME="terminal.json"
      WT_COLOR_SCHEME="Gotham"

      # Terminal.app
      TERM_FILENAME="Gotham.terminal"

      # vim
      VIMPLUG_COLORSCHEME="whatyouhide/vim-gotham"
      VIM_COLORSCHEME="gotham"

      # VS Code
      VSCODE_ICON_EXTENSION="PKief.material-icon-theme"
      VSCODE_ICON_THEME="material-icon-theme"

      VSCODE_COLOR_EXTENSION="alireza94.theme-gotham"
      VSCODE_COLOR_THEME="Gotham"

      apply_theme
      ;;
    sekiguchi)
      NVIM_FILENAME="colorscheme.lua"
      NVIM_COLORSCHEME="sekiguchi"
      NVIM_LOCAL_PLUGIN_DIR=$APPEARANCE_DIR/src/themes/$theme/sekiguchi.nvim

      WT_FILENAME="terminal.json"
      WT_COLOR_SCHEME="Sekiguchi"

      TERM_FILENAME="Sekiguchi.terminal"

      VIMPLUG_COLORSCHEME=""
      VIM_COLORSCHEME="sekiguchi"
      VIM_LOCAL_RUNTIME_DIR=$APPEARANCE_DIR/src/themes/$theme/vim

      VSCODE_ICON_THEME="material-icon-theme"
      VSCODE_COLOR_THEME="Sekiguchi"
      VSCODE_EXTENSION_PATH=$APPEARANCE_DIR/src/themes/$theme/vscode

      apply_theme
      ;;
    *)
      echo "Error: Unknown theme '$theme'."
      exit 1
      ;;
  esac
}

apply_theme() {
  echo "Applying theme: $theme"

  # Windows Terminal
  if [ $(uname) = Darwin ]; then
    echo "(mac)"

  elif [ $(uname) = Linux ]; then
    if [ -n "$WSL_DISTRO_NAME" ]; then
      echo "(wsl)"

      WINDOWS_HOME=$(wslpath $(powershell.exe '$env:UserProfile') | sed -e 's/\r//g')
      # Expand glob safely using array and quotes
      shopt -s nullglob
      WINDOWS_TERMINAL_SETTINGS_DIR=("$WINDOWS_HOME"/AppData/Local/Packages/Microsoft.WindowsTerminal*/LocalState)

      if [ ${#WINDOWS_TERMINAL_SETTINGS_DIR[@]} -eq 0 ]; then
          echo "Settings directory not found"
          exit 1
      fi
      # Pick first match
      WINDOWS_TERMINAL_SETTINGS_DIR="${WINDOWS_TERMINAL_SETTINGS_DIR[0]}"
      SETTINGS_FILE=$WINDOWS_TERMINAL_SETTINGS_DIR/settings.json
      echo $SETTINGS_FILE

      echo $APPEARANCE_DIR/src/themes/$theme/$WT_FILENAME
      jq --arg color_scheme "$WT_COLOR_SCHEME" \
      --slurpfile theme $APPEARANCE_DIR/src/themes/$theme/$WT_FILENAME \
      '.schemes = [$theme[0]] | .profiles.list |= map(if .source == "Windows.Terminal.Wsl" then .colorScheme = $color_scheme else . end)' \
      $SETTINGS_FILE \
      > temp.json && mv temp.json $SETTINGS_FILE
      echo "Updated Windows Terminal colorScheme to '$WT_COLOR_SCHEME'."

    elif [ -n "$CODESPACES" ]; then
      echo "(github codespaces)"

    else
      echo "(native linux)"

    fi
  fi

  # Terminal.app
  if [ $(uname) = Darwin ]; then
  echo "(mac)"

osascript <<EOD
tell application "Terminal"
    local allOpenedWindows
    local initialOpenedWindows
    local windowID
    set themeName to "$theme"
    set themeFilePath to "$APPEARANCE_DIR/src/themes/$theme/$TERM_FILENAME"

    (* Store the IDs of all the open terminal windows *)
    set initialOpenedWindows to id of every window

    (* Check if the theme already exists in the list of Terminal settings *)
    if not (exists settings set themeName) then
        (* Open the custom theme so that it gets added to the list of available terminal themes *)
        do shell script "open '" & themeFilePath & "'"

        (* Wait a little bit to ensure that the custom theme is added *)
        delay 1
    end if

    (* Set the custom theme as the default terminal theme *)
    set default settings to settings set themeName

    (* Get the IDs of all the currently opened terminal windows *)
    set allOpenedWindows to id of every window

    repeat with windowID in allOpenedWindows
        (* Close the additional windows that were opened in order
           to add the custom theme to the list of terminal themes *)
        if initialOpenedWindows does not contain windowID then
            close (every window whose id is windowID)
        else
            (* Change the theme for the initial opened terminal windows
               to remove the need to close them in order for the custom
               theme to be applied *)
            set current settings of tabs of (every window whose id is windowID) to settings set themeName
        end if
    end repeat
end tell
EOD

  fi

  # VS Code

  if [ $(uname) = Darwin ]; then
    echo "(mac)"

    VSCODE_USER_SETTINGS_DIR=$HOME/Library/Application\ Support/Code/User
    VSCODE_EXTENSIONS_DIR=$HOME/.vscode/extensions

  elif [ $(uname) = Linux ]; then
    if [ -n "$WSL_DISTRO_NAME" ]; then
      echo "(wsl)"

      WINDOWS_HOME=$(wslpath $(powershell.exe '$env:UserProfile') | sed -e 's/\r//g')
      VSCODE_USER_SETTINGS_DIR=$WINDOWS_HOME/AppData/Roaming/Code/User
      VSCODE_EXTENSIONS_DIR=$WINDOWS_HOME/.vscode/extensions

    elif [ -n "$CODESPACES" ]; then
      echo "(github codespaces)"

    else
      echo "(native linux)"

      VSCODE_USER_SETTINGS_DIR=$HOME/.config/Code/User
      VSCODE_EXTENSIONS_DIR=$HOME/.vscode/extensions
    fi
  fi

  if command -v code &>/dev/null; then

    if [ -n "$VSCODE_ICON_EXTENSION" ]; then
      code --install-extension "$VSCODE_ICON_EXTENSION" >/dev/null
    fi
    if [ -n "$VSCODE_ICON_THEME" ]; then
      conditional_sed -i "s/\"workbench.iconTheme\": \".*\"/\"workbench.iconTheme\": \"$VSCODE_ICON_THEME\"/g" "$VSCODE_USER_SETTINGS_DIR"/settings.json
    fi

    if [ -n "$VSCODE_EXTENSION_PATH" ]; then
      install_vscode_extension_path "$VSCODE_EXTENSION_PATH"
    elif [ -n "$VSCODE_COLOR_EXTENSION" ]; then
      code --install-extension "$VSCODE_COLOR_EXTENSION" >/dev/null
    fi
    if [ -n "$VSCODE_COLOR_THEME" ]; then
      conditional_sed -i "s/\"workbench.colorTheme\": \".*\"/\"workbench.colorTheme\": \"$VSCODE_COLOR_THEME\"/g" "$VSCODE_USER_SETTINGS_DIR"/settings.json
    fi
  fi

  # Shell

  conditional_sed -i "s/^THEME_NAME=.*/THEME_NAME=\"$theme\"/" $XDG_CONFIG_HOME/zsh/.zshrc

  # Prompt

  ln -sf "$APPEARANCE_DIR/src/themes/$theme/starship.toml" "$XDG_CONFIG_HOME/starship.toml"

  # vim

  conditional_sed -i "s|^let g:vim_plug_colorscheme = \".*\"|let g:vim_plug_colorscheme = \"$VIMPLUG_COLORSCHEME\"|" $XDG_CONFIG_HOME/vim/vimrc

  conditional_sed -i "s|^let g:colorscheme = \".*\"|let g:colorscheme = \"$VIM_COLORSCHEME\"|" $XDG_CONFIG_HOME/vim/vimrc

  if [ -n "$VIM_LOCAL_RUNTIME_DIR" ]; then
    mkdir -p "$XDG_CONFIG_HOME/vim/colors" "$XDG_CONFIG_HOME/vim/autoload/airline/themes"
    cp -f "$VIM_LOCAL_RUNTIME_DIR/colors/$VIM_COLORSCHEME.vim" "$XDG_CONFIG_HOME/vim/colors/$VIM_COLORSCHEME.vim"
    cp -f "$VIM_LOCAL_RUNTIME_DIR/autoload/airline/themes/$VIM_COLORSCHEME.vim" "$XDG_CONFIG_HOME/vim/autoload/airline/themes/$VIM_COLORSCHEME.vim"
  fi

  vim -u "$XDG_CONFIG_HOME/vim/vimrc" +silent! +PlugInstall +PlugClean! +qall

  # nvim

  NVIM_USER_PLUGINS_DIR=$XDG_CONFIG_HOME/nvim/lua/plugins
  mkdir -p $NVIM_USER_PLUGINS_DIR && cp -f $APPEARANCE_DIR/src/themes/$theme/colorscheme.lua $NVIM_USER_PLUGINS_DIR/colorscheme.lua

  nvim --headless "+Lazy! sync" +"colorscheme $NVIM_COLORSCHEME" +qa

}

export -f set_theme
export -f apply_theme
export -f conditional_sed
export -f install_vscode_extension_path
