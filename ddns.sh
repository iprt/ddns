#!/bin/bash
# shellcheck disable=SC2164 disable=SC2034 disable=SC2086 disable=SC2086
SHELL_FOLDER=$(cd "$(dirname "$0")" && pwd)
cd "$SHELL_FOLDER"

source ./env_func.sh

# 定义全局变量
RR=$1
DOMAIN=$2

function ddns_start() {
  log "ddns.sh" ">>> dynamic dns start <<<"
}
function ddns_end() {
  log "ddns.sh" ">>> dynamic dns end <<<"
}

if ! command_exists jq; then
  log "prepare" "jq 命令不存在"
  ddns_end
  exit
fi

if ! command_exists nc; then
  log "prepare" "nc 命令不存在"
  ddns_end
  exit
fi

function verify_param() {
  if [ -z "$RR" ]; then
    log "ddns.sh" "主机记录 不能为空"
    ddns_end
    exit
  fi

  if [ -z "$DOMAIN" ]; then
    log "ddns.sh" "域名 不能为空"
    ddns_end
    exit
  fi
}

verify_param

bash ip_cache.sh
ip_cache_status=$?

if [ $ip_cache_status -ne 0 ]; then
  log "ddns.sh" "ip_cache.sh 执行失败，退出"
  ddns_end
  exit
fi

ip_cache=$(cat ip.cache)

# aliyun-cli 操作 dns记录
bash ddns/ddns.sh $RR $DOMAIN $ip_cache

log "ddns.sh" ">>> dynamic dns end <<<"
