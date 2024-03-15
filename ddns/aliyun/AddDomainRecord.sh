#!/bin/bash
# shellcheck disable=SC2164 disable=SC2086
SHELL_FOLDER=$(cd "$(dirname "$0")" && pwd)
cd "$SHELL_FOLDER"

source ../../commons/commons/logger.sh

RR=$1
DOMAIN=$2
ip_cache=$3

# 验证方法: 删除所有DNS记录
function AddDomainRecord() {
  log "AddDomainRecord" "========== AddDomainRecord =========="
  log "AddDomainRecord" "aliyun alidns AddDomainRecord --DomainName $DOMAIN --RR $RR --Type A --Value $ip_cache"

  aliyun alidns AddDomainRecord --DomainName $DOMAIN --RR $RR --Type A --Value $ip_cache
}

AddDomainRecord
