#!/bin/bash
# Maintainer MMX 
# Email 4isnothing@gmail.com
add_rules()
{
curl 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | grep ipv4 | grep CN | awk -F\| '{ printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > cn_ipv4.list
wait

# Add new ipset
ipset -N chnroute hash:net maxelem 65536

for ip in $(cat cn_ipv4.list)
do
  echo "Add ip $ip to ipset."
  ipset add chnroute $ip
done

CHAIN_NAME='BYPASSLIST'

# Add new chain $CHAIN_NAME
iptables -t nat -N $CHAIN_NAME

# Add server IP
# iptables -t nat -A $CHAIN_NAME -d $SERVER_IP -j RETURN

# LAN IP
iptables -t nat -A $CHAIN_NAME -d 0.0.0.0/8 -j RETURN
iptables -t nat -A $CHAIN_NAME -d 10.0.0.0/8 -j RETURN
iptables -t nat -A $CHAIN_NAME -d 127.0.0.0/8 -j RETURN
iptables -t nat -A $CHAIN_NAME -d 169.254.0.0/16 -j RETURN
iptables -t nat -A $CHAIN_NAME -d 172.16.0.0/12 -j RETURN
iptables -t nat -A $CHAIN_NAME -d 192.168.0.0/16 -j RETURN
iptables -t nat -A $CHAIN_NAME -d 224.0.0.0/4 -j RETURN
iptables -t nat -A $CHAIN_NAME -d 240.0.0.0/4 -j RETURN

# ipset match
iptables -t nat -A $CHAIN_NAME -p tcp -m set --match-set chnroute dst -j RETURN
iptables -t nat -A $CHAIN_NAME -p icmp -m set --match-set chnroute dst -j RETURN

#for ip in $(cat cn_ipv4.list)
#do
#  echo "iptables -t nat -A $CHAIN_NAME -d $ip -j RETURN"
#  echo "iptables -t nat -A $CHAIN_NAME -d $ip -j RETURN" >> iptables_bypass.sh
#  iptables -t nat -A $CHAIN_NAME -d $ip -j RETURN
#done

echo 'Done.'
}

del_rules()
{
iptables -t nat -F $CHAIN_NAME
iptables -t nat -X $CHAIN_NAME
ipset destroy chnroute
echo 'Done.'
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

