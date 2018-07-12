#!/bin/bash
# Maintainer MMX 
# Email 4isnothing@gmail.com
add_rules()
{
curl 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | grep ipv4 | grep CN | awk -F\| '{ printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > cn_ipv4.list
wait

# Add new chain BYPASSLIST
iptables -t nat -N BYPASSLIST

for ip in $(cat cn_ipv4.list)
do
  echo "iptables -t nat -A BYPASSLIST -d $ip -j RETURN"
  echo "iptables -t nat -A BYPASSLIST -d $ip -j RETURN" >> iptables_bypass.sh
  iptables -t nat -A BYPASSLIST -d $ip -j RETURN
done

echo "Finished"
}

del_rules()
{
iptables -t nat -F BYPASSLIST
iptables -t nat -X BYPASSLIST
}

backup_iptables()
{
iptables-save > iptables.conf
}

restore_iptables()
{
iptables-restore < iptables.conf
}

"$@"

