#!/bin/bash
# shellcheck disable=SC2164
SHELL_FOLDER=$(cd "$(dirname "$0")" && pwd)
cd "$SHELL_FOLDER"

function log() {
  local remark=$1
  local msg=$2
  if [ -z "$remark" ]; then
    remark="default_remark"
  fi
  if [ -z "$msg" ]; then
    msg="empty msg by log default"
  fi
  bash ../../log.sh "$remark" "$msg"
}

log "aws" "todo"
