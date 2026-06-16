#!/usr/bin/env bash

source "$APPEARANCE_DIR/src/themes/registry.sh"

card_help() {
  cat <<EOF
Usage: appearance card [OPTIONS]

Themes:
$(list_themes | sed 's/^/  /')

Options:
  -n, --name     Specify the theme name
  help           Show this help message
EOF
}

if [[ "$#" -lt 1 ]]; then
  card_help
  exit 1
fi

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -n|--name)
      if [[ -n "$2" && ! "$2" =~ ^- ]]; then
        load_theme_registry "$2"
        "$APPEARANCE_DIR/src/themes/$2/theme-card.sh"
        shift 2
      else
        echo "Error: Missing value for --name"
        exit 1
      fi
      ;;
    help)
      card_help
      exit 0
      ;;
    -*|--*)
      echo "Unknown option: $1"
      exit 1
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done
