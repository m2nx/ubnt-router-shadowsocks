#!/bin/bash
# Maintainer MMX 
# Email 4isnothing@gmail.com
curl 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | grep ipv4 | grep CN | awk -F\| '{ printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > cn_ipv4.list
wait

# Add new chain BYPASSLIST
iptables -t nat -N BYPASSLIST

for ip in $(cat cn_ipv4.list)
do
  echo "iptables -t nat -A BYPASSLIST -d $ip -j RETURN" >> iptables_bypass.sh
  iptables -t nat -A BYPASSLIST -d $ip -j RETURN
done

echo "Finished"


