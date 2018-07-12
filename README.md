# chn_iptables
Auto generate chn iptables

# How to use

There are four functions in the shell script.

* add_rules  
Add all chn IPs to iptables table 'nat' chain 'BYPASSLIST'  
```shell
./install.sh add_rules
```

* del_rules  
Delete chain 'BYPASSLIST'  
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
