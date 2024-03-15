#!/bin/bash
# shellcheck disable=SC2164  disable=SC2002
SHELL_FOLDER=$(cd "$(dirname "$0")" && pwd)
cd "$SHELL_FOLDER"

source ../commons/logger.sh

# 定义全局变量
RR=$1
DOMAIN=$2
ip_cache=$3

ddns_policy=$(cat ../config.json | jq -r ".ddns_policy")

if [ -z "$ddns_policy" ]; then
  log "config" "ddns_policy 配置不能为空"
  exit
elif [ ! -f "$ddns_policy/ddns.sh" ]; then
  log "config" "ddns_policy ddns执行文件不存在：$ddns_policy/ddns.sh"
  exit
else
  log "config" "ddns_policy 配置成功, 策略为: $ddns_policy"
fi

# shellcheck disable=SC2086
bash $ddns_policy/ddns.sh $RR $DOMAIN $ip_cache
