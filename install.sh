#!/bin/bash

read -p "请输入服务器地址: " SERVER_IP
echo $SERVER_IP
read -p "请输入服务器端口: " SERVER_PORT
echo $SERVER_PORT
echo "请选择服务器加密方式: "
echo "1 chacha20-ietf-poly1305" "2 aes-128-gcm" "3 chacha20" "4 rc4-md5" "5 salsa20" "6 aes-256-cfb"
select method in "1" "2" "3" "4" "5" "6";do
  case $method in
    1)SERVER_METHOD="chacha20-ietf-poly1305";break;;
    2)SERVER_METHOD="aes-128-gcm";break;;
    3)SERVER_METHOD="chacha20";break;;
    4)SERVER_METHOD="rc4-md5";break;;
    5)SERVER_METHOD="salsa20";break;;
    6)SERVER_METHOD="aes-256-cfb";break;;
  esac
done
echo $SERVER_METHOD
read -p "请输入服务器密码: " SERVER_PASS
echo $SERVER_PASS


echo $SERVER_IP
echo $SERVER_PORT
echo $SERVER_METHOD
echo $SERVER_PASS
cp conf.d/ss-supervisord.conf conf.d/shadowsocks.conf
sed -i "s|{ip}|$SERVER_IP|g" conf.d/shadowsocks.conf
sed -i "s|{port}|$SERVER_PORT|g" conf.d/shadowsocks.conf
sed -i "s|{method}|$SERVER_METHOD|g" conf.d/shadowsocks.conf
sed -i "s|{pass}|$SERVER_PASS|g" conf.d/shadowsocks.conf
exit
cp conf.d/shadowsocks.conf /etc/supervisor/conf.d/shadowsocks.conf
