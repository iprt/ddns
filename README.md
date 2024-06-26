# dynamic dns

基于阿里云CLI

解析IPV4

<!-- TOC -->

* [dynamic dns](#dynamic-dns)
    * [一、准备条件](#一准备条件)
        * [1.1 下载项目](#11-下载项目)
        * [1.2 其他需要的命令](#12-其他需要的命令)
        * [1.3 aliyun-cli 配置](#13-aliyun-cli-配置)
    * [二、使用说明](#二使用说明)
    * [三、自定义 ip 获取策略](#三自定义-ip-获取策略)
    * [四、脚本生成的文件](#四脚本生成的文件)
    * [五、一些其他配置](#五一些其他配置)

<!-- TOC -->

## 一、准备条件

### 1.1 下载项目

```shell
git clone https://github.com/iprt/ddns
```

### 1.2 其他需要的命令

`nc`: 测试远程tcp端口是否打开

`curl`

`aliyun-cli`: https://github.com/aliyun/aliyun-cli

`jq`: 解析`aliyun-cli`的`json`返回值

### 1.3 aliyun-cli 配置

```shell
aliyun configure 
```

```text
Configuring profile 'default' in 'AK' authenticate mode...
Access Key Id []: <Access Key Id>
Access Key Secret []: <Access Key Secret>
Default Region Id []: <Default Region Id>
Default Output Format [json]: json (Only support json)
Default Language [zh|en] en: zh
Saving profile[default] ...Done.

Configure Done!!!
..............888888888888888888888 ........=8888888888888888888D=..............
...........88888888888888888888888 ..........D8888888888888888888888I...........
.........,8888888888888ZI: ...........................=Z88D8888888888D..........
.........+88888888 ..........................................88888888D..........
.........+88888888 .......Welcome to use Alibaba Cloud.......O8888888D..........
.........+88888888 ............. ************* ..............O8888888D..........
.........+88888888 .... Command Line Interface(Reloaded) ....O8888888D..........
.........+88888888...........................................88888888D..........
..........D888888888888DO+. ..........................?ND888888888888D..........
...........O8888888888888888888888...........D8888888888888888888888=...........
............ .:D8888888888888888888.........78888888888888888888O ..............
```

- `Access Key Id`: 略
- `Access Key Secret`:略
- `Default Region Id`: `cn-shanghai`
- `Default Language`: `zh`

## 二、使用说明

**例:** 修改 `test.example.com` 的解析记录(A)为当前网络的出口IP(v4)

- `test` 为dns记录
- `example.com` 为个人持有的域名

```shell
bash /path_to_ddns/ddns.sh test example.com 
```

- 参数一: `test`: DNS记录
- 参数二: `example.com`: 个人持有的域名

**定时任务**

```shell
crontab -e
```

例子: 每5分钟执行一次[`ddns.sh`](ddns.sh)，修改 `test.example.com` , `test` 为dns记录 ，`example.com` 为域名

```text
 */5 * * * * /bin/bash /path_to_ddns/ddns.sh test example.com 
```

## 三、自定义 ip 获取策略

> 参考 [ip_get](ip_get) 文件夹，配置文件 [`config.json`](config.json) 中配置

windows 使用 `git-bash` 测试可以使用 `taobao` 策略

**约定:**

1. IP获取策略需要将获取到的`公网ip（类似 127.0.0.1 ）`写入到`ip_get.cache`文件中，`ip_cache.sh`会读取、校验、删除
2. 自编写策略文件名: `ip_get_<自编写策略>.sh`

个人实现

- [ip_get_ipcrystal.sh](ip_get/ip_get_ipcrystal.sh) 通过 `https://www.ipcrystal.com/ddns` 获取公网IP
- [ip_get_taobao.sh](ip_get/ip_get_taobao.sh) 通过 `https://www.taobao.com/help/getip.php` 获取公网IP

## 四、脚本生成的文件

缓存文件: `ip.cache`

临时缓存: `ip_get.cache`

日志文件: `ddns.log`

## 五、一些其他配置

`nginx` 配置 `location` `/ddns` 获取 IP

```nginx configuration
    location = /ddns {
        default_type text/plain;
        return 200 '$remote_addr';
    }
```
