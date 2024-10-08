#!/bin/bash
# shellcheck disable=SC2164 disable=SC2155 disable=SC2086
SHELL_FOLDER=$(cd "$(dirname "$0")" && pwd)
cd "$SHELL_FOLDER"

source ../../env_func.sh

RR=$1
DOMAIN=$2
ip_cache=$3

function validate_param() {
  if [ -z "$RR" ]; then
    log "validate_param" "RR 不能为空"
    exit
  fi

  if [ -z "$DOMAIN" ]; then
    log "validate_param" "DOMAIN 不能为空"
    exit
  fi

  if [ -z "$ip_cache" ]; then
    log "validate_param" "ip_cache 不能为空"
    exit
  fi

}

validate_param

function validate_cli() {
  default_valid_status=$(aliyun configure list | grep default | awk -F '|' '{print $3}' | xargs)
  if [ "$default_valid_status" == "Valid" ]; then
    log "validate_cli" "阿里云CLI 配置成功 default_valid_status: $default_valid_status"
  else
    log "validate_cli" "阿里云CLI 配置失败 default_valid_status: $default_valid_status"
    exit
  fi
}

validate_cli

# 注意 方法内部不能加echo 加了注释输出的内容 jq 读取有问题
function DescribeSubDomainRecords() {
  aliyun alidns DescribeSubDomainRecords --SubDomain $RR.$DOMAIN
}

# 验证方法: 删除所有DNS记录
function AddDomainRecord() {
  log "AddDomainRecord" "========== AddDomainRecord =========="
  log "AddDomainRecord" "aliyun alidns AddDomainRecord --DomainName $DOMAIN --RR $RR --Type A --Value $ip_cache"

  aliyun alidns AddDomainRecord --DomainName $DOMAIN --RR $RR --Type A --Value $ip_cache
}

# 验证方法: 新增多条DNS记录
function DeleteSubDomainRecords() {
  log "DeleteSubDomainRecords" "========== DeleteSubDomainRecords =========="

  # shellcheck disable=SC2051
  for RecordId in $(DescribeSubDomainRecords | jq -r ".DomainRecords.Record[].RecordId"); do
    log "DeleteSubDomainRecords" "delete RecordId : RecordId=$RecordId"
  done

  log "DeleteSubDomainRecords" "aliyun alidns DeleteSubDomainRecords --RR $RR --DomainName $DOMAIN"

  aliyun alidns DeleteSubDomainRecords --RR $RR --DomainName $DOMAIN
}

# 验证方法: DNS记录更新成其他IP
function UpdateDomainRecord() {
  log "UpdateDomainRecord" "========== UpdateDomainRecord =========="

  local record_value=$(DescribeSubDomainRecords | jq -r ".DomainRecords.Record[0].Value")

  if [ "$record_value" == "$ip_cache" ]; then
    log "UpdateDomainRecord" "本地IP缓存($ip_cache)与远程DNS解析($record_value)相同，不需要修改"
  else
    log "UpdateDomainRecord" "本地IP缓存($ip_cache)与远程DNS解析($record_value)不同，需要修改"
    local local_RecordId=$(DescribeSubDomainRecords | jq -r ".DomainRecords.Record[0].RecordId")

    log "UpdateDomainRecord" "aliyun alidns UpdateDomainRecord --RR $RR --RecordId $local_RecordId --Type A --Value $ip_cache"

    aliyun alidns UpdateDomainRecord --RR $RR --RecordId $local_RecordId --Type A --Value $ip_cache
  fi
}

function dynamic_dns() {
  local record_count=$(DescribeSubDomainRecords | jq ".TotalCount")

  if [ $record_count -eq 0 ]; then
    log "dynamic_dns" "域名 $RR.$DOMAIN 的DNS记录个数为 $record_count，执行AddDomainRecord"
    AddDomainRecord
  fi

  if [ $record_count -eq 1 ]; then
    log "dynamic_dns" "域名 $RR.$DOMAIN 的DNS记录个数为 $record_count，执行 UpdateDomainRecord "
    UpdateDomainRecord
  fi

  if [ $record_count -gt 1 ]; then
    log "dynamic_dns" "域名 $RR.$DOMAIN 的DNS记录个数为 $record_count (>1)，未知错误，删除所有原来的DNS记录，执行 DeleteSubDomainRecords、AddDomainRecord"
    DeleteSubDomainRecords
    AddDomainRecord
  fi

}

dynamic_dns

show_result=$(DescribeSubDomainRecords)
log "show" "查询域名 $RR.$DOMAIN 的所有DNS记录\n$show_result"
