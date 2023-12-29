#!/bin/bash
# shellcheck disable=SC2164
SHELL_FOLDER=$(
  cd "$(dirname "$0")"
  pwd
)
cd "$SHELL_FOLDER"

# ip 获取策略
# shellcheck disable=SC2034
ip_get_policy=$(cat config.json | jq -r ".ip_get_policy")

if [ -z "$ip_get_policy" ]; then
  /bin/bash log.sh "config" "IP 获取策略配置不能为空"
  exit 1
elif [ ! -f "ip_get/ip_get_$ip_get_policy.sh" ]; then
  /bin/bash log.sh "config" "IP 获取策略 指定的的文件不存在: ip_get/ip_get_$ip_get_policy.sh"
  exit 1
else
  /bin/bash log.sh "config" "IP 获取策略 配置成功"
fi

ip_get_cache="ip_get/ip_get.cache"
ip_cache="ip.cache"

function cache_refresh() {
  /bin/bash log.sh "cache_refresh" "========== cache_refresh =========="
  if [ ! -f "$ip_cache" ]; then
    /bin/bash log.sh "cache_refresh" "新建 $ip_cache 缓存文件"
    echo "127.0.0.1" >"$ip_cache"
  fi

  /bin/bash log.sh "cache_refresh" "当前的IP获取策略为: $ip_get_policy"

  /bin/bash "ip_get/ip_get_$ip_get_policy.sh"

  if [ ! -f $ip_get_cache ]; then
    /bin/bash log.sh "cache_refresh" "$ip_get_cache 临时缓存文件不存在，确保 ip_get.sh 生成 $ip_get_cache 文件"
    exit 1
  fi

  # 获取公网IP 从 ip_get.cache 中获取
  # shellcheck disable=SC2155
  local public_ip=$(cat $ip_get_cache)

  # 验证 公网IP是否正确
  /bin/bash ip_valid.sh "$public_ip"
  ip_valid_status=$?

  /bin/bash log.sh "cache_refresh" "ip_valid_status $ip_valid_status"

  # shellcheck disable=SC2086
  if [ $ip_valid_status -ne 0 ]; then
    # 公网IP验证失败
    exit 1
  else
    /bin/bash log.sh "cache_refresh" "清理$ip_get_cache: rm -rf $ip_get_cache"
    rm -rf $ip_get_cache
  fi

  # shellcheck disable=SC2155
  local local_ip_cache=$(cat $ip_cache)

  if [ "init" == "$local_ip_cache" ]; then
    /bin/bash log.sh "cache_refresh" "ip cache 初始化，第一次写入$ip_cache"
    echo "$public_ip" >$ip_cache
  elif [ "$local_ip_cache" == "$public_ip" ]; then
    /bin/bash log.sh "cache_refresh" "缓存的IP与当前的IP相同，ddns 执行时可选择重新校验"
  else
    /bin/bash log.sh "cache_refresh" "重写本地IP缓存，之前的IP缓存为: $local_ip_cache,新的缓存为: $public_ip"
    echo "$public_ip" >$ip_cache
  fi

}

cache_refresh
