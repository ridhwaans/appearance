#!/usr/bin/env bash

set -e

APPEARANCE_DIR=${APPEARANCE_DIR:-$HOME/Source/appearance}
PRESET_NAME=${PRESET_NAME:-gotham}

$APPEARANCE_DIR/bin/appearance preset --name "$PRESET_NAME"
