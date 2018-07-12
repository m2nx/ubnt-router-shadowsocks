# chn_iptables
Auto generate chn iptables

# How to use

There are four functions in the shell script.

* add_rules  
Add all chn IPs to iptables table 'nat' chain 'BYPASSLIST'. If you execute this function before, you need delete BYPASSLIST rule in PREROUTING chain manually.
```shell
./install.sh add_rules
```

* del_rules  
Delete chain 'BYPASSLIST', add_rules will automatically call this function.  
```shell
./install.sh del_rules
```

* backup_iptables  
As it said. Backup iptables configuration to iptables.conf  
```shell
./install.sh backup_iptables
```

* restore_iptables  
Restore iptables from iptables.conf 
```shell
./install.sh restore_iptables
```

Then your iptables nat should look like this
```shell
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
BYPASSLIST  tcp  --  anywhere             anywhere

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination

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
