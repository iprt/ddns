#!/bin/bash
# shellcheck disable=SC2164
SHELL_FOLDER=$(cd "$(dirname "$0")" && pwd)
cd "$SHELL_FOLDER"

source ../env_func.sh

function check_port() {
  local SERVER=$1
  local PORT=$2

  local timeout=1

  nc -w $timeout -z "$SERVER" "$PORT"
  local status=$?

  if [ $status -ne 0 ]; then
    log "check_port" "Connection to $SERVER on port $PORT failed"
    log "check_port" "exit"
    exit 1
  else
    log "check_port" "Connection to $SERVER on port $PORT succeeded"
  fi
}

# 测试需要获取ip的服务器端口是否打开
check_port ipcrystal.com 443

# 约定: 写入临时缓存 ip_get.cache
log "get ip" "curl -sSL -k https://ipcrystal.com/ddns >ip_get.cache"
curl -sSL -k https://ipcrystal.com/ddns >ip_get.cache
