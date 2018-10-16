# ubnt-router-shadowsocks  
在 usg，edgerouter 等设备上安装 ss 的一键脚本，包括 dnsmasq 配置，以及 iptables，国内 ip 走直连，除此以外默认走代理。

# 说明

此脚本执行后将处理的任务：  

1. 要求填写服务器 ip，端口，密码，以及加密方式，然后生成 supervisord 配置文件。  

2. 自动配置 iptables 和 [dnsmasq-china-list](https://github.com/felixonmars/dnsmasq-china-list.git)

3. 将配置信息写入启动脚本 rc.local，默认重启后重写 iptables。

# 安装步骤以及要求  
以 USG 举例
1. 先设置 apt-get 的 source，然后安装必备的软件
[EdgeRouter-Add-other-Debian-packages-to-EdgeOS](https://help.ubnt.com/hc/en-us/articles/205202560-EdgeRouter-Add-other-Debian-packages-to-EdgeOS)  
```
configure
set system package repository wheezy components 'main contrib non-free' 
set system package repository wheezy distribution wheezy 
set system package repository wheezy url http://http.us.debian.org/debian
commit ; save
sudo -i
apt-get update
apt-get install supervisorctl
```
2. 执行脚本  
按照提示填入服务器信息，等待脚本执行完毕后确认 /etc/dnsmasq.d/ 有相关文件。  

* iptables 样例  

```shell
Chain BYPASSLIST (1 references)
target     prot opt source               destination
RETURN     all  --  anywhere             123.123.123.123
RETURN     all  --  anywhere             0.0.0.0/8
RETURN     all  --  anywhere             10.0.0.0/8
RETURN     all  --  anywhere             127.0.0.0/8
RETURN     all  --  anywhere             link-local/16
RETURN     all  --  anywhere             172.16.0.0/12
RETURN     all  --  anywhere             192.168.0.0/16
RETURN     all  --  anywhere             base-address.mcast.net/4
RETURN     all  --  anywhere             240.0.0.0/4
RETURN     tcp  --  anywhere             anywhere             match-set chnlist dst
```
3. 安装 shadowsocks-libev  
架构是 mips 和 mips64 的可以去我这个仓库 [ubnt-mips-shadowsocks-libev](https://github.com/imMMX/ubnt-mips-shadowsocks-libev) 下载或者自己编译。解压缩后移动到 /usr/bin/ 中或者 /usr/local/bin/ 确保 ss-redir ss-tunnel 可以直接执行。不知道自己是什么架构的输入 uname -a 查看

```
uname -a
wget https://github.com/imMMX/ubnt-mips-shadowsocks-libev/releases/download/3.2.0/ss-mips64.zip
```

4. 启动 supervisord  
```
supervisorctl
reload
```
