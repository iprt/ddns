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

# 验证方法: 新增多条DNS记录
function DeleteSubDomainRecords() {
  log "DeleteSubDomainRecords" "========== DeleteSubDomainRecords =========="

  # shellcheck disable=SC2086
  for RecordId in $(/bin/bash DescribeSubDomainRecords.sh $RR $DOMAIN | jq -r ".DomainRecords.Record[].RecordId"); do
    log "DeleteSubDomainRecords" "delete RecordId : RecordId=$RecordId"
  done

  log "DeleteSubDomainRecords" "aliyun alidns DeleteSubDomainRecords --RR $RR --DomainName $DOMAIN"

  # shellcheck disable=SC2086
  aliyun alidns DeleteSubDomainRecords --RR $RR --DomainName $DOMAIN
}

DeleteSubDomainRecords
