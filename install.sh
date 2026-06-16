#!/usr/bin/env bash

set -e

SCRIPT_ROOT=$(dirname ${BASH_SOURCE[0]})
export APPEARANCE_DIR=$(cd $SCRIPT_ROOT && pwd)
DOTFILES_DIR=${DOTFILES_DIR:-$HOME/Source/dotfiles}
APPEARANCE_PROFILE=$DOTFILES_DIR/appearance/profile.env

if [ -f "$APPEARANCE_PROFILE" ]; then
    set -a
    source "$APPEARANCE_PROFILE"
    set +a
fi

if [ -z "$PRESET_NAME" ]; then
    echo "PRESET_NAME is not set. Configure $APPEARANCE_PROFILE or export PRESET_NAME."
    exit 1
fi

$APPEARANCE_DIR/bin/appearance preset --name "$PRESET_NAME"
