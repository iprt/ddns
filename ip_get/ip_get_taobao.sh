#!/bin/bash
# shellcheck disable=SC2164
SHELL_FOLDER=$(cd "$(dirname "$0")" && pwd)
cd "$SHELL_FOLDER"

# 通过淘宝获取IP
# 返回值类似 "ipCallback({ip:"127.0.0.1"})"
taobao_get_ip=$(curl -k https://www.taobao.com/help/getip.php)

ip=$(echo "$taobao_get_ip" | sed -n 's/.*ip:"\([^"]*\).*/\1/p')

# 约定: 写入临时缓存 ip_get.cache
echo "$ip" >ip_get.cache
