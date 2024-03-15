#!/bin/bash
# shellcheck disable=SC2164
SHELL_FOLDER=$(cd "$(dirname "$0")" && pwd)
cd "$SHELL_FOLDER"

function log() {
  local log_remark="$1"
  local log_message="$2"
  local log_file=ddns.log
  local current_time
  current_time=$(date +"%Y-%m-%d %H:%M:%S")
  echo -e "$current_time - [ $log_remark ] $log_message"
  echo -e "$current_time - [ $log_remark ] $log_message" >>"$log_file"
}

remark=$1
msg=$2

log "$remark" "$msg"
