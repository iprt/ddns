#!/bin/bash
# shellcheck disable=SC2164
SHELL_FOLDER=$(
  cd "$(dirname "$0")"
  pwd
)
cd "$SHELL_FOLDER"

# 定义全局变量
RR=$1
DOMAIN=$2
ip_cache=$3

# shellcheck disable=SC2034
ddns_policy=$(cat ../config.json | jq -r ".ddns_policy")

if [ -z "$ddns_policy" ]; then
  /bin/bash ../log.sh "config" "ddns_policy 配置不能为空"
  exit
elif [ ! -f "$ddns_policy/ddns.sh" ]; then
  /bin/bash ../log.sh "config" "ddns_policy ddns执行文件不存在：$ddns_policy/ddns.sh"
  exit
else
  /bin/bash ../log.sh "config" "ddns_policy 配置成功, 策略为: $ddns_policy"
fi

# shellcheck disable=SC2086
/bin/bash $ddns_policy/ddns.sh $RR $DOMAIN $ip_cache
