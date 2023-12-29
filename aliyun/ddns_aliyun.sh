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

function validate_cli() {
  default_valid_status=$(aliyun configure list | grep default | awk -F '|' '{print $3}' | xargs)
  if [ "$default_valid_status" == "Valid" ]; then
    /bin/bash ../log.sh "validate_cli" "阿里云CLI 配置成功 default_valid_status: $default_valid_status"
  else
    /bin/bash ../log.sh "validate_cli" "阿里云CLI 配置失败 default_valid_status: $default_valid_status"
    exit
  fi
}

validate_cli

# 注意 方法内部不能加echo 加了注释输出的内容 jq 读取有问题
function DescribeSubDomainRecords() {
  # shellcheck disable=SC2086
  aliyun alidns DescribeSubDomainRecords --SubDomain $RR.$DOMAIN
}

# 验证方法: 删除所有DNS记录
function AddDomainRecord() {
  /bin/bash ../log.sh "AddDomainRecord" "========== AddDomainRecord =========="
  /bin/bash ../log.sh "AddDomainRecord" "aliyun alidns AddDomainRecord --DomainName $DOMAIN --RR $RR --Type A --Value $ip_cache"

  # shellcheck disable=SC2086
  aliyun alidns AddDomainRecord --DomainName $DOMAIN --RR $RR --Type A --Value $ip_cache
}

# 验证方法: 新增多条DNS记录
function DeleteSubDomainRecords() {
  /bin/bash ../log.sh "DeleteSubDomainRecords" "========== DeleteSubDomainRecords =========="

  # shellcheck disable=SC2051
  for RecordId in $(DescribeSubDomainRecords | jq -r ".DomainRecords.Record[].RecordId"); do
    /bin/bash ../log.sh "DeleteSubDomainRecords" "delete RecordId : RecordId=$RecordId"
  done

  /bin/bash ../log.sh "DeleteSubDomainRecords" "aliyun alidns DeleteSubDomainRecords --RR $RR --DomainName $DOMAIN"

  # shellcheck disable=SC2086
  aliyun alidns DeleteSubDomainRecords --RR $RR --DomainName $DOMAIN
}

# 验证方法: DNS记录更新成其他IP
function UpdateDomainRecord() {
  /bin/bash ../log.sh "UpdateDomainRecord" "========== UpdateDomainRecord =========="

  # shellcheck disable=SC2155
  local record_value=$(DescribeSubDomainRecords | jq -r ".DomainRecords.Record[0].Value")

  if [ "$record_value" == "$ip_cache" ]; then
    /bin/bash ../log.sh "UpdateDomainRecord" "本地IP缓存($ip_cache)与远程DNS解析($record_value)相同，不需要修改"
  else
    /bin/bash ../log.sh "UpdateDomainRecord" "本地IP缓存($ip_cache)与远程DNS解析($record_value)不同，需要修改"
    # shellcheck disable=SC2155
    local local_RecordId=$(DescribeSubDomainRecords | jq -r ".DomainRecords.Record[0].RecordId")

    /bin/bash ../log.sh "UpdateDomainRecord" "aliyun alidns UpdateDomainRecord --RR $RR --RecordId $local_RecordId --Type A --Value $ip_cache"

    # shellcheck disable=SC2086
    aliyun alidns UpdateDomainRecord --RR $RR --RecordId $local_RecordId --Type A --Value $ip_cache
  fi
}

function dynamic_dns() {
  # shellcheck disable=SC2155
  local record_count=$(DescribeSubDomainRecords | jq ".TotalCount")

  # shellcheck disable=SC2086
  if [ $record_count -eq 0 ]; then
    /bin/bash ../log.sh "dynamic_dns" "域名 $RR.$DOMAIN 的DNS记录个数为 $record_count，执行AddDomainRecord"
    AddDomainRecord
  fi

  # shellcheck disable=SC2086
  if [ $record_count -eq 1 ]; then
    /bin/bash ../log.sh "dynamic_dns" "域名 $RR.$DOMAIN 的DNS记录个数为 $record_count，执行 UpdateDomainRecord "
    UpdateDomainRecord
  fi

  # shellcheck disable=SC2086
  if [ $record_count -gt 1 ]; then
    /bin/bash ../log.sh "dynamic_dns" "域名 $RR.$DOMAIN 的DNS记录个数为 $record_count (>1)，未知错误，删除所有原来的DNS记录，执行 DeleteSubDomainRecords、AddDomainRecord"
    DeleteSubDomainRecords
    AddDomainRecord
  fi

}

dynamic_dns

/bin/bash ../log.sh "show" "查询域名 $RR.$DOMAIN 的所有DNS记录"
show_result=$(DescribeSubDomainRecords)
/bin/bash ../log.sh "show" "$show_result"
