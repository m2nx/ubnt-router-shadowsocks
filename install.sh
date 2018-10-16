#!/bin/bash

read -p "请输入服务器地址: " SERVER_IP
echo $SERVER_IP
read -p "请输入服务器端口: " SERVER_PORT
echo $SERVER_PORT
echo "请选择服务器加密方式: "
select method in "chacha20-ietf-poly1305" "aes-128-gcm" "chacha20" "rc4-md5" "salsa20" "aes-256-cfb";do
  case $method in
    chacha20-ietf-poly1305 )SERVER_METHOD="chacha20-ietf-poly1305";break;;
    aes-128-gcm )SERVER_METHOD="aes-128-gcm";break;;
    chacha20 )SERVER_METHOD="chacha20";break;;
    rc4-md5 )SERVER_METHOD="rc4-md5";break;;
    salsa20 )SERVER_METHOD="salsa20";break;;
    aes-256-cf )SERVER_METHOD="aes-256-cfb";break;;
  esac
done
echo $SERVER_METHOD
read -p "请输入服务器密码: " SERVER_PASS
echo $SERVER_PASS

echo "信息如下，请核对："
green="\033[0;32m"
end="\033[0m"
echo -e "${green}服务器地址：$SERVER_IP"
echo "端口："$SERVER_PORT
echo "加密方式："$SERVER_METHOD
echo -e "密码："$SERVER_PASS${end}
echo "是否继续？"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo "OK!";break;;
        No ) exit;;
    esac
done

cp conf.d/ss-supervisord.conf conf.d/shadowsocks.conf
sed -i "s|{ip}|$SERVER_IP|g" conf.d/shadowsocks.conf
sed -i "s|{port}|$SERVER_PORT|g" conf.d/shadowsocks.conf
sed -i "s|{method}|$SERVER_METHOD|g" conf.d/shadowsocks.conf
sed -i "s|{pass}|$SERVER_PASS|g" conf.d/shadowsocks.conf
sed -i "s|# SERVER_IP|SERVER_IP=$SERVER_IP|g" iptables.sh
cp conf.d/shadowsocks.conf /etc/supervisor/conf.d/shadowsocks.conf
