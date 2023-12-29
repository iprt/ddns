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

# 验证方法: DNS记录更新成其他IP
function UpdateDomainRecord() {
  /bin/bash ../../log.sh "UpdateDomainRecord" "========== UpdateDomainRecord =========="

  # shellcheck disable=SC2086
  # shellcheck disable=SC2155
  local record_value=$(/bin/bash DescribeSubDomainRecords.sh $RR $DOMAIN | jq -r ".DomainRecords.Record[0].Value")

  if [ "$record_value" == "$ip_cache" ]; then
    /bin/bash ../../log.sh "UpdateDomainRecord" "本地IP缓存与远程DNS解析相同，不需要修改"
  else
    /bin/bash ../../log.sh "UpdateDomainRecord" "本地IP缓存与远程DNS解析不同，需要修改"
    # shellcheck disable=SC2155
    local local_RecordId=$(DescribeSubDomainRecords | jq -r ".DomainRecords.Record[0].RecordId")

    /bin/bash ../../log.sh "UpdateDomainRecord" "aliyun alidns UpdateDomainRecord --RR $RR --RecordId $local_RecordId --Type A --Value $ip_cache"

    # shellcheck disable=SC2086
    aliyun alidns UpdateDomainRecord --RR $RR --RecordId $local_RecordId --Type A --Value $ip_cache
  fi
}

UpdateDomainRecord
