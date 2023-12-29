#!/bin/bash
# shellcheck disable=SC2164
SHELL_FOLDER=$(
  cd "$(dirname "$0")"
  pwd
)
cd "$SHELL_FOLDER"

function log() {
  /bin/bash ../../log.sh $1 $2
}

log "aws" "todo"
