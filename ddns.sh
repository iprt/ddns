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

/bin/bash log.sh "ddns.sh" ">>> dynamic dns start <<<"

function verify_param() {
  if [ -z "$RR" ]; then
    /bin/bash log.sh "ddns.sh" "主机记录 不能为空"
    exit
  fi

  if [ -z "$DOMAIN" ]; then
    /bin/bash log.sh "ddns.sh" "域名 不能为空"
    exit
  fi
}

verify_param

# shellcheck disable=SC2034
/bin/bash ip_cache.sh
ip_cache_status=$?

# shellcheck disable=SC2086
if [ $ip_cache_status -ne 0 ]; then
  /bin/bash log.sh "ddns.sh" "ip_cache.sh 执行失败，退出"
  exit
fi

ip_cache=$(cat ip.cache)

# aliyun-cli 操作 dns记录
# shellcheck disable=SC2086
/bin/bash ddns_aliyun.sh $RR $DOMAIN $ip_cache

/bin/bash log.sh "ddns.sh" ">>> dynamic dns end <<<"
