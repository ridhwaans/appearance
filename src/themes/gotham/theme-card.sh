#!/usr/bin/env bash

set -euo pipefail

theme_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
theme_name="Gotham"
theme_intent="dark, high-contrast terminal and editor theme"
terminal_profile_file="Gotham.terminal"
vim_colors_file="vim/colors/gotham.vim"
airline_file="vim/autoload/airline/themes/gotham.vim"
vscode_theme_file="vscode/themes/gotham-color-theme.json"
nvim_note="Neovim uses the external neogotham plugin through colorscheme.lua."

source "$theme_dir/../theme-card.sh"
