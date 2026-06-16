#!/usr/bin/env bash

load_preset_registry() {
  local preset=$1

  case "$preset" in
    gotham)
      PRESET_THEME="gotham"
      PRESET_FONT="Roboto Mono"
      ;;
    sekiguchi)
      PRESET_THEME="sekiguchi"
      PRESET_FONT="Space Mono"
      ;;
    *)
      echo "Error: Unknown preset '$preset'."
      exit 1
      ;;
  esac
}

export -f load_preset_registry
