#!/bin/bash
# shellcheck disable=SC2164
SHELL_FOLDER=$(
  cd "$(dirname "$0")"
  pwd
)
cd "$SHELL_FOLDER"

RR=$1
DOMAIN=$2
ip_cache=$3

# 验证方法: 删除所有DNS记录
function AddDomainRecord() {
  /bin/bash ../../log.sh "AddDomainRecord" "========== AddDomainRecord =========="
  /bin/bash ../../log.sh "AddDomainRecord" "aliyun alidns AddDomainRecord --DomainName $DOMAIN --RR $RR --Type A --Value $ip_cache"

  # shellcheck disable=SC2086
  aliyun alidns AddDomainRecord --DomainName $DOMAIN --RR $RR --Type A --Value $ip_cache
}

AddDomainRecord
