#!/bin/bash
# shellcheck disable=SC2164 disable=SC2086
SHELL_FOLDER=$(cd "$(dirname "$0")" && pwd)
cd "$SHELL_FOLDER"

source ../../env_func.sh

RR=$1
DOMAIN=$2

# 验证方法: 新增多条DNS记录
function DeleteSubDomainRecords() {
  log "DeleteSubDomainRecords" "========== DeleteSubDomainRecords =========="

  for RecordId in $(bash DescribeSubDomainRecords.sh $RR $DOMAIN | jq -r ".DomainRecords.Record[].RecordId"); do
    log "DeleteSubDomainRecords" "delete RecordId : RecordId=$RecordId"
  done

  log "DeleteSubDomainRecords" "aliyun alidns DeleteSubDomainRecords --RR $RR --DomainName $DOMAIN"

  aliyun alidns DeleteSubDomainRecords --RR $RR --DomainName $DOMAIN
}

DeleteSubDomainRecords
