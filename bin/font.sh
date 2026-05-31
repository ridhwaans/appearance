#!/usr/bin/env bash

font_help() {
  cat <<EOF
Usage: appearance font [OPTIONS]

Fonts:
  Roboto Mono
  SF Mono
  Space Mono

Options:
  -n, --name     Specify the font name
  help           Show this help message
EOF
}

if [[ "$#" -lt 1 ]]; then
  font_help
  exit 1
fi

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -n|--name)
      if [[ -n "$2" && ! "$2" =~ ^- ]]; then
        set_font_by_name "$2"
        shift 2
      else
        echo "Error: Missing value for --name"
        exit 1
      fi
      ;;
    help)
      font_help
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
