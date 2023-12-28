# dynamic dns

基于阿里云

解析IPV4

## 准备条件

### linux 需要的命令行

`nc`: 测试远程tcp端口是否打开

`curl`

`aliyun-cli`: https://github.com/aliyun/aliyun-cli

`jq`: 解析`aliyun-cli`的`json`返回值

### aliyun-cli 配置

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

## 使用说明

```text
/bin/bash ddns.sh test example.com
```

- 第一个参数 `test`: DNS记录
- 第二个参数 `ipcrystal.com`: 域名

## 自定义 `ip_get.sh`

<font color=red>约定: </font>获取到的`公网ip（类似 127.0.0.1 ）`写入到`ip_get.cache`文件中，`ip_cache.sh`会读取、校验、删除

一些 `ip_get.sh` 的实现

- 参考 [ip_get](ip_get)

## 执行

例子: 修改 `test.example.com` , `test` 为dns记录 ，`example.com` 为域名

```shell
/bin/bash /path_to_ddns/ddns.sh test example.com 
```

**定时任务**

```shell
crontab -e
```

例子: 每5分钟执行一次[`ddns.sh`](ddns.sh)，修改 `test.example.com` , `test` 为dns记录 ，`example.com` 为域名

```text
 */5 * * * * /bin/bash /path_to_ddns/ddns.sh test example.com 
```

## 脚本生成的文件

缓存文件: `ip.cache`

临时缓存: `ip_get.cache`

日志文件: `ddns.log`
