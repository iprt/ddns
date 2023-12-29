#!/bin/bash

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
  /bin/bash ../log.sh "valid_ip" "$ip_address is a valid IP address."
  exit 0
else
  /bin/bash ../log.sh "valid_ip" "$ip_address is not a valid IP address."
  exit 1
fi
