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
  bash ../log.sh "$remark" "$msg"
}

function valid_ip() {
  local ip=$1
  local valid_ip_regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'

  # check format using regex
  if [[ ! $ip =~ $valid_ip_regex ]]; then
    return 1
  fi

  # check each octet range
  IFS='.' read -ra octets <<<"$ip"
  for octet in "${octets[@]}"; do
    if ((octet < 0 || octet > 255)); then
      return 1
    fi
  done

  return 0
}

ip_address="$1"
if valid_ip "$ip_address"; then
  log "valid_ip" "$ip_address is a valid IP address."
  exit 0
else
  log "valid_ip" "$ip_address is not a valid IP address."
  exit 1
fi
