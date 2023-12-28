#!/bin/bash

function check_port() {
  local SERVER=$1
  local PORT=$2

  local timeout=1

  nc -w $timeout -z "$SERVER" "$PORT"
  local status=$?

  # shellcheck disable=SC2086
  if [ $status -ne 0 ]; then
    /bin/bash log.sh "check_port" "Connection to $SERVER on port $PORT failed"
    /bin/bash log.sh "check_port" "exit"
    exit 1
  else
    /bin/bash log.sh "check_port" "Connection to $SERVER on port $PORT succeeded"
  fi
}

# 测试需要获取ip的服务器端口是否打开
check_port ipcrystal.com 443

# 约定: 写入 ip_get.cache
curl -k https://ipcrystal.com/ddns >ip_get.cache
