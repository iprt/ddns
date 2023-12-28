#!/bin/bash
# 通过淘宝获取IP
# 返回值类似 "ipCallback({ip:"127.0.0.1"})"
# shellcheck disable=SC2034
taobao_get_ip=$(curl https://www.taobao.com/help/getip.php)

ip=$(echo "$taobao_get_ip" | sed -n 's/.*ip:"\([^"]*\).*/\1/p')

# 如果使用，按照约定
#echo "$ip" >ip_get.cache

echo "$ip"
