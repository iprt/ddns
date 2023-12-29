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
ddns_policy=$(cat ddns_policy)

/bin/bash $ddns_policy/ddns.sh $RR $DOMAIN $ip_cache
