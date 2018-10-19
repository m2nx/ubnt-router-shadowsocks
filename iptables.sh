#!/bin/bash
# Maintainer MMX
# Email 4isnothing@gmail.com
# SERVER_IP
add_rules()
{
    #curl 'https://raw.githubusercontent.com/17mon/china_ip_list/master/china_ip_list.txt' > cn_ipv4.list
    curl 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | grep ipv4 | grep CN | awk -F\| '{ printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > cn_ipv4.list
    wait
    CHAIN_NAME='BYPASSLIST'

    del_rules
    # Add new ipset
    ipset destroy chnlist
    ipset -N chnlist hash:net maxelem 65536

    echo 'ipset processing...'
    ipset add chnlist $SERVER_IP
    ipset add chnlist 0.0.0.0/8
    ipset add chnlist 10.0.0.0/8
    ipset add chnlist 127.0.0.0/8
    ipset add chnlist 169.254.0.0/16
    ipset add chnlist 172.16.0.0/12
    ipset add chnlist 192.168.0.0/16
    ipset add chnlist 224.0.0.0/4
    ipset add chnlist 240.0.0.0/4

    for ip in $(cat cn_ipv4.list)
    do
        ipset add chnlist $ip
    done
    echo 'ipset done.'

    # Add server IP
    if [ -n "$SERVER_IP" ]
    then
        echo "Your server IP is $SERVER_IP"
    else
        read -p "Please set server IP:" SERVER_IP
    fi

    # 1. TCP
    # TCP new chain $CHAIN_NAME
    iptables -t nat -N $CHAIN_NAME
    # TCP ipset match
    iptables -t nat -A $CHAIN_NAME -p tcp -m set --match-set chnlist dst -j RETURN
    # TCP redirect
    iptables -t nat -A $CHAIN_NAME -p tcp -j REDIRECT --to-ports 1080
    # TCP rule to prerouting chain
    iptables -t nat -A PREROUTING -p tcp -j $CHAIN_NAME
    # For local
    #iptables -t nat -I OUTPUT -p tcp -j $CHAIN_NAME

    # 2. UDP
    # TCP new chain $CHAIN_NAME
    iptables -t mangle -N $CHAIN_NAME
    ip route add local default dev lo table 100
    ip rule add fwmark 1 lookup 100

    # UDP ipset match
    iptables -t mangle -A $CHAIN_NAME -p udp -m set --match-set chnlist dst -j RETURN
    iptables -t mangle -A $CHAIN_NAME -p udp -j TPROXY --on-port 1080 --tproxy-mark 0x01/0x01

    # UDP rule to pretouting chain
    iptables -t mangle -A PREROUTING -p udp -j $CHAIN_NAME

    echo 'Done.'
}

del_rules()
{
    ipset destroy chnroute
    iptables -t nat -F $CHAIN_NAME
    iptables -t nat -X $CHAIN_NAME
    echo 'Del_rules Done.'
}

backup_iptables()
{
    iptables-save > iptables.conf
    echo 'Done.'
}

restore_iptables()
{
    iptables-restore < iptables.conf
    echo 'Done.'
}

"$@"

