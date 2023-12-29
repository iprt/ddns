#!/bin/bash
# shellcheck disable=SC2164
SHELL_FOLDER=$(
  cd "$(dirname "$0")"
  pwd
)
cd "$SHELL_FOLDER"

RR=$1
DOMAIN=$2

# 验证方法: 新增多条DNS记录
function DeleteSubDomainRecords() {
  /bin/bash ../../log.sh "DeleteSubDomainRecords" "========== DeleteSubDomainRecords =========="

  # shellcheck disable=SC2086
  for RecordId in $(/bin/bash DescribeSubDomainRecords.sh $RR $DOMAIN | jq -r ".DomainRecords.Record[].RecordId"); do
    /bin/bash ../../log.sh "DeleteSubDomainRecords" "delete RecordId : RecordId=$RecordId"
  done

  /bin/bash ../../log.sh "DeleteSubDomainRecords" "aliyun alidns DeleteSubDomainRecords --RR $RR --DomainName $DOMAIN"

  # shellcheck disable=SC2086
  aliyun alidns DeleteSubDomainRecords --RR $RR --DomainName $DOMAIN
}

DeleteSubDomainRecords
