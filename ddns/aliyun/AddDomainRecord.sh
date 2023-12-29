#!/bin/bash
# shellcheck disable=SC2164
SHELL_FOLDER=$(
  cd "$(dirname "$0")"
  pwd
)
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
  /bin/bash ../../log.sh "$remark" "$msg"
}

RR=$1
DOMAIN=$2
ip_cache=$3

# 验证方法: 删除所有DNS记录
function AddDomainRecord() {
  log "AddDomainRecord" "========== AddDomainRecord =========="
  log "AddDomainRecord" "aliyun alidns AddDomainRecord --DomainName $DOMAIN --RR $RR --Type A --Value $ip_cache"

  # shellcheck disable=SC2086
  aliyun alidns AddDomainRecord --DomainName $DOMAIN --RR $RR --Type A --Value $ip_cache
}

AddDomainRecord
