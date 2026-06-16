#!/usr/bin/env bash

source "$APPEARANCE_DIR/src/presets/registry.sh"

preset_help() {
  cat <<EOF
Usage: appearance preset [OPTIONS]

Presets:
$(list_presets | sed 's/^/  /')

Options:
  -n, --name     Specify the preset name
  help           Show this help message
EOF
}

[ "$#" -lt 1 ] && preset_help && exit 1

while [ "$#" -gt 0 ]; do
  case "$1" in
    -n|--name)
      load_preset_registry "$2"
      $APPEARANCE_DIR/bin/appearance theme --name "$PRESET_THEME"
      $APPEARANCE_DIR/bin/appearance font --name "$PRESET_FONT"
      shift 2
      ;;
    help)
      preset_help
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done
