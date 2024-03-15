#!/bin/bash
# shellcheck disable=SC2164 disable=SC2034 disable=SC2086
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
  /bin/bash log.sh "$remark" "$msg"
}

# 定义全局变量
RR=$1
DOMAIN=$2

log "ddns.sh" ">>> dynamic dns start <<<"

function verify_param() {
  if [ -z "$RR" ]; then
    log "ddns.sh" "主机记录 不能为空"
    log "ddns.sh" ">>> dynamic dns end <<<"
    exit
  fi

  if [ -z "$DOMAIN" ]; then
    log "ddns.sh" "域名 不能为空"
    log "ddns.sh" ">>> dynamic dns end <<<"
    exit
  fi
}

verify_param

/bin/bash ip_cache.sh
ip_cache_status=$?

if [ $ip_cache_status -ne 0 ]; then
  log "ddns.sh" "ip_cache.sh 执行失败，退出"
  exit
fi

ip_cache=$(cat ip.cache)

# aliyun-cli 操作 dns记录
# shellcheck disable=SC2086
/bin/bash ddns/ddns.sh $RR $DOMAIN $ip_cache

log "ddns.sh" ">>> dynamic dns end <<<"
