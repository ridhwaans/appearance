#!/usr/bin/env bash

preset_help() {
  cat <<EOF
Usage: appearance preset [OPTIONS]

Presets:
  gotham
  sekiguchi

Options:
  -n, --name     Specify the preset name
  help           Show this help message
EOF
}

[ "$#" -lt 1 ] && preset_help && exit 1

while [ "$#" -gt 0 ]; do
  case "$1" in
    -n|--name)
      case "$2" in
        gotham)
          $APPEARANCE_DIR/bin/appearance theme --name gotham
          $APPEARANCE_DIR/bin/appearance font --name "Roboto Mono"
          ;;
        sekiguchi)
          $APPEARANCE_DIR/bin/appearance theme --name sekiguchi
          $APPEARANCE_DIR/bin/appearance font --name "Space Mono"
          ;;
        *)
          echo "Error: Unknown preset '$2'."
          exit 1
          ;;
      esac
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
