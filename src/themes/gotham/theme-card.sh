#!/usr/bin/env bash

set -euo pipefail

theme_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
theme_name="Gotham"

extract_text_colors() {
  local path="$1"

  if [[ ! -f "$path" ]]; then
    return 0
  fi

  grep -Eoh '#[0-9A-Fa-f]{6}|[0-9a-f]{2}/[0-9a-f]{2}/[0-9a-f]{2}|(^|[[:space:]])[0-9a-f]{6}($|[[:space:]])' "$path" \
    | tr '[:upper:]' '[:lower:]' \
    | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' \
    | sed 's|/||g; s|^#||' \
    | sed 's|^|#|' \
    | sort -u
}

extract_terminal_colors() {
  local path="$1"

  if [[ ! -f "$path" ]]; then
    return 0
  fi

  python3 - "$path" <<'PY'
import plistlib
import sys

path = sys.argv[1]

try:
    outer = plistlib.load(open(path, "rb"))
except Exception:
    sys.exit(0)

colors = []
for key, value in outer.items():
    if not key.endswith("Color") or not isinstance(value, bytes):
        continue
    try:
        inner = plistlib.loads(value)
        color = inner["$objects"][1]
        components = color.get("NSComponents") or color.get("NSRGB")
        if isinstance(components, bytes):
            components = components.decode("ascii")
        components = components.rstrip("\x00")
        rgb = [float(part) for part in components.split()[:3]]
    except Exception:
        continue
    colors.append("#" + "".join(f"{round(channel * 255):02x}" for channel in rgb))

for color in sorted(set(colors)):
    print(color)
PY
}

hex_to_rgb() {
  local hex="${1#'#'}"

  printf '%d %d %d\n' "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

contrast_fg() {
  local r="$1"
  local g="$2"
  local b="$3"
  local luminance

  luminance=$((r * 299 + g * 587 + b * 114))
  if (( luminance > 128000 )); then
    printf '0;0;0'
  else
    printf '255;255;255'
  fi
}

color_chip() {
  local color="$1"
  local r g b

  read -r r g b < <(hex_to_rgb "$color")
  printf '\033[48;2;%s;%s;%sm  \033[0m %s' "$r" "$g" "$b" "$color"
}

print_color_grid() {
  local color
  local index=0
  local terminal_cols="${COLUMNS:-}"
  local grid_columns

  if [[ ! "$terminal_cols" =~ ^[0-9]+$ ]]; then
    terminal_cols="$(tput cols 2>/dev/null || printf '80')"
  fi

  grid_columns=$(((terminal_cols + 4) / 16))
  (( grid_columns < 1 )) && grid_columns=1

  for color in "$@"; do
    printf '  '
    color_chip "$color"
    index=$((index + 1))
    if (( index % grid_columns == 0 )); then
      printf '\n'
    else
      printf '    '
    fi
  done

  if (( index % grid_columns != 0 )); then
    printf '\n'
  fi
}

collect_colors() {
  local kind="$1"
  local path="$2"

  if [[ "$kind" == "terminal" ]]; then
    extract_terminal_colors "$theme_dir/$path"
  else
    extract_text_colors "$theme_dir/$path"
  fi
}

color_count() {
  local colors="$1"

  if [[ -z "$colors" ]]; then
    printf '0'
  else
    printf '%s\n' "$colors" | sed '/^$/d' | wc -l | tr -d ' '
  fi
}

join_colors() {
  paste -sd ' ' -
}

section() {
  local title="$1"
  printf '\n+------------------------------------------------------------------------------+\n'
  printf '| %-76s |\n' "$title"
  printf '+------------------------------------------------------------------------------+\n'
}

fit_text() {
  local text="$1"
  local width="$2"

  if (( ${#text} <= width )); then
    printf '%s' "$text"
  else
    printf '%s...%s' "${text:0:$((width - 8))}" "${text: -5}"
  fi
}

title_card() {
  local display_dir
  display_dir="$(fit_text "$theme_dir" 61)"

  printf '+------------------------------------------------------------------------------+\n'
  printf '| %-76s |\n' "$theme_name Theme System Card"
  printf '+------------------------------------------------------------------------------+\n'
  printf '| %-14s %-61s |\n' "Directory:" "$display_dir"
  printf '| %-14s %-61s |\n' "Intent:" "dark, high-contrast terminal and editor theme"
  printf '+------------------------------------------------------------------------------+\n'
}

artifact_row() {
  local target="$1"
  local path="$2"
  local status="missing"
  local display_path

  [[ -f "$theme_dir/$path" ]] && status="ok"
  display_path="$(fit_text "$path" 34)"
  printf '| %-31s | %-7s | %-34s |\n' "$target" "$status" "$display_path"
}

artifact_table() {
  section "Artifacts"
  printf '| %-31s | %-7s | %-34s |\n' "Target" "Status" "Path"
  printf '+---------------------------------+---------+------------------------------------+\n'
  artifact_row "Terminal escape theme" "theme.sh"
  artifact_row "Windows Terminal scheme" "terminal.json"
  artifact_row "macOS Terminal profile" "Gotham.terminal"
  artifact_row "Starship prompt" "starship.toml"
  artifact_row "Lazy.nvim loader" "colorscheme.lua"
  printf '+---------------------------------+---------+------------------------------------+\n'
}

palette_panel() {
  local label="$1"
  local kind="$2"
  local path="$3"
  local colors=()
  local color

  while IFS= read -r color; do
    [[ -n "$color" ]] && colors+=("$color")
  done < <(collect_colors "$kind" "$path")

  printf '\n%-28s %2d colors  %s\n' "$label" "${#colors[@]}" "$path"
  printf -- '------------------------------------------------------------------------------\n'

  if [[ ${#colors[@]} -eq 0 ]]; then
    printf '  no colors detected\n'
  else
    print_color_grid "${colors[@]}"
  fi
}

palette_inventory() {
  section "Palette Inventory"
  palette_panel "Shell terminal" text "theme.sh"
  palette_panel "Windows Terminal" text "terminal.json"
  palette_panel "macOS Terminal" terminal "Gotham.terminal"
  palette_panel "Starship prompt" text "starship.toml"
}

compare_palette() {
  local label="$1"
  local kind="$2"
  local path="$3"

  local terminal_palette current missing extra
  terminal_palette="$(extract_text_colors "$theme_dir/theme.sh")"
  current="$(collect_colors "$kind" "$path")"

  missing="$(comm -23 <(printf '%s\n' "$terminal_palette") <(printf '%s\n' "$current"))"
  extra="$(comm -13 <(printf '%s\n' "$terminal_palette") <(printf '%s\n' "$current"))"

  printf '%s\t%s\t%s\t%s\n' "$label" "$(color_count "$current")" "$(color_count "$missing")" "$(color_count "$extra")"
}

consistency_matrix() {
  local rows

  section "Consistency Matrix"
  printf 'Base reference: theme.sh terminal palette. Extra colors are usually UI-only.\n\n'
  printf '+------------------------+--------+---------+-------+\n'
  printf '| %-22s | %-6s | %-7s | %-5s |\n' "Target" "Colors" "Missing" "Extra"
  printf '+------------------------+--------+---------+-------+\n'
  rows="$(
    compare_palette "Windows Terminal" text "terminal.json"
    compare_palette "macOS Terminal" terminal "Gotham.terminal"
    compare_palette "Starship prompt" text "starship.toml"
  )"
  while IFS=$'\t' read -r label colors missing extra; do
    printf '| %-22s | %6s | %7s | %5s |\n' "$label" "$colors" "$missing" "$extra"
  done <<< "$rows"
  printf '+------------------------+--------+---------+-------+\n'
}

detail_diff_panel() {
  local label="$1"
  local kind="$2"
  local path="$3"
  local terminal_palette current missing extra
  local colors=()
  local color

  terminal_palette="$(extract_text_colors "$theme_dir/theme.sh")"
  current="$(collect_colors "$kind" "$path")"
  missing="$(comm -23 <(printf '%s\n' "$terminal_palette") <(printf '%s\n' "$current"))"
  extra="$(comm -13 <(printf '%s\n' "$terminal_palette") <(printf '%s\n' "$current"))"

  printf '\n%s\n' "$label"
  printf -- '------------------------------------------------------------------------------\n'

  if [[ -z "$missing" ]]; then
    printf '  missing: none\n'
  else
    printf '  missing:\n'
    colors=()
    while IFS= read -r color; do
      [[ -n "$color" ]] && colors+=("$color")
    done <<< "$missing"
    print_color_grid "${colors[@]}"
  fi

  if [[ -z "$extra" ]]; then
    printf '  extra:   none\n'
  else
    printf '  extra:\n'
    colors=()
    while IFS= read -r color; do
      [[ -n "$color" ]] && colors+=("$color")
    done <<< "$extra"
    print_color_grid "${colors[@]}"
  fi
}

diff_details() {
  section "Diff Details"
  detail_diff_panel "Windows Terminal" text "terminal.json"
  detail_diff_panel "macOS Terminal" terminal "Gotham.terminal"
  detail_diff_panel "Starship prompt" text "starship.toml"
}

notes_panel() {
  section "Notes"
  printf '  * theme.sh, Gotham.terminal, and terminal.json ANSI colors should align.\n'
  printf '  * Neovim uses the external neogotham plugin through colorscheme.lua.\n'
  printf '  * Gotham does not currently ship local Vim, vim-airline, or VS Code theme artifacts.\n'
  printf '  * colorscheme.lua is a loader spec, not a palette source.\n'
}

main() {
  title_card
  artifact_table
  palette_inventory
  consistency_matrix
  diff_details
  notes_panel
}

main "$@"
