#!/usr/bin/env bash

set -euo pipefail

theme_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
theme_name="Sekiguchi"
theme_intent="light, sterile biotech-inspired UI and terminal theme"
terminal_profile_file="Sekiguchi.terminal"
vim_colors_file="vim/colors/sekiguchi.vim"
airline_file="vim/autoload/airline/themes/sekiguchi.vim"
vscode_theme_file="vscode/themes/sekiguchi-color-theme.json"
nvim_note="Neovim reads colors from the ridhwaans/sekiguchi.nvim Lazy plugin."

source "$theme_dir/../theme-card.sh"
