#!/bin/bash
# shellcheck disable=SC2164 disable=SC2086 disable=SC2155
SHELL_FOLDER=$(cd "$(dirname "$0")" && pwd)
cd "$SHELL_FOLDER"

source ../../env_func.sh

RR=$1
DOMAIN=$2
ip_cache=$3

# 验证方法: DNS记录更新成其他IP
function UpdateDomainRecord() {
  log "UpdateDomainRecord" "========== UpdateDomainRecord =========="

  local record_value=$(bash DescribeSubDomainRecords.sh $RR $DOMAIN | jq -r ".DomainRecords.Record[0].Value")

  if [ "$record_value" == "$ip_cache" ]; then
    log "UpdateDomainRecord" "本地IP缓存与远程DNS解析相同，不需要修改"
  else
    log "UpdateDomainRecord" "本地IP缓存与远程DNS解析不同，需要修改"

    local local_RecordId=$(DescribeSubDomainRecords | jq -r ".DomainRecords.Record[0].RecordId")

    log "UpdateDomainRecord" "aliyun alidns UpdateDomainRecord --RR $RR --RecordId $local_RecordId --Type A --Value $ip_cache"

    aliyun alidns UpdateDomainRecord --RR $RR --RecordId $local_RecordId --Type A --Value $ip_cache
  fi
}

UpdateDomainRecord
