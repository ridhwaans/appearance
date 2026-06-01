#!/usr/bin/env bash

set -e

SCRIPT_ROOT=$(dirname ${BASH_SOURCE[0]})
export APPEARANCE_DIR=$(cd $SCRIPT_ROOT && pwd)

PRESET_NAME=${PRESET_NAME:-gotham}

$APPEARANCE_DIR/bin/appearance preset --name "$PRESET_NAME"
