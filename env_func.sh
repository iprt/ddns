#!/bin/bash
# shellcheck disable=SC2164
PROJECT_PATH=$(cd "$(dirname "$0")" && pwd)

function log() {
  local log_remark="$1"
  local log_message="$2"

  if [ -z "$log_remark" ]; then
    log_remark="empty remark"
  fi

  if [ -z "$log_message" ]; then
    log_message="empty message"
  fi

  local log_file=$PROJECT_PATH/ddns.log
  local current_time
  current_time=$(date +"%Y-%m-%d %H:%M:%S")
  echo -e "$current_time - [ $log_remark ] $log_message"
  echo -e "$current_time - [ $log_remark ] $log_message" >>"$log_file"
}

function command_exists() {
  type "$1" &>/dev/null
}

function validate_ipv4() {
  local ip=$1
  local regex='^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'

  if [[ $ip =~ $regex ]]; then
    log "validate_ip" "Valid IP"
  else
    log "validate_ip" "Invalid IP"
    return 1
  fi
}
