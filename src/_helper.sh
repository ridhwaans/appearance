#!/usr/bin/env bash

conditional_sed() {
    # use gnu sed for no explicit backup in-place editing on mac
    if [ $(uname) = Darwin ]; then
        gsed "$@"
    else
        sed "$@"
    fi
}

set_vscode_setting() {
  local settings_file=$1
  local key=$2
  local value=$3
  local escaped_value

  escaped_value=${value//\\/\\\\}
  escaped_value=${escaped_value//&/\\&}
  escaped_value=${escaped_value//|/\\|}

  if grep -q "\"$key\":" "$settings_file"; then
    conditional_sed -i "s|\"$key\": \".*\"|\"$key\": \"$escaped_value\"|g" "$settings_file"
  else
    conditional_sed -i "0,/{/s|{|{\n\t\"$key\": \"$escaped_value\",|" "$settings_file"
  fi
}

export -f conditional_sed
export -f set_vscode_setting
