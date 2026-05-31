#!/usr/bin/env bash

set -e

SCRIPT_ROOT=$(dirname ${BASH_SOURCE[0]})
export APPEARANCE_DIR=$(cd $SCRIPT_ROOT && pwd)

$APPEARANCE_DIR/src/configs.sh
