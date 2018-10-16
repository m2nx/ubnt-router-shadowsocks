#!/bin/bash
set -e

WORKDIR="$(mktemp -d)"
SERVERS=(114.114.114.114)
# Not using best possible CDN pop: 1.2.4.8 210.2.4.8 223.5.5.5 223.6.6.6
# Dirty cache: 119.29.29.29 182.254.116.116

CONF_WITH_SERVERS=(accelerated-domains.china)
CONF_SIMPLE=(bogus-nxdomain.china)

echo "Downloading latest configurations..."
git clone --depth=1 https://git.coding.net/felixonmars/dnsmasq-china-list.git "$WORKDIR"
#git clone --depth=1 https://pagure.io/dnsmasq-china-list.git "$WORKDIR"
#git clone --depth=1 https://github.com/felixonmars/dnsmasq-china-list.git "$WORKDIR"
#git clone --depth=1 https://bitbucket.org/felixonmars/dnsmasq-china-list.git "$WORKDIR"
#git clone --depth=1 https://gitee.com/felixonmars/dnsmasq-china-list.git "$WORKDIR"
#git clone --depth=1 https://gitlab.com/felixonmars/dnsmasq-china-list.git "$WORKDIR"
#git clone --depth=1 https://code.aliyun.com/felixonmars/dnsmasq-china-list.git "$WORKDIR"
#git clone --depth=1 http://repo.or.cz/dnsmasq-china-list.git "$WORKDIR"

echo "Removing old configurations..."
for _conf in "${CONF_WITH_SERVERS[@]}" "${CONF_SIMPLE[@]}"; do
rm -f /etc/dnsmasq.d/"$_conf"*.conf
done

echo "Installing new configurations..."
for _conf in "${CONF_SIMPLE[@]}"; do
cp "$WORKDIR/$_conf.conf" "/etc/dnsmasq.d/$_conf.conf"
done

for _server in "${SERVERS[@]}"; do
for _conf in "${CONF_WITH_SERVERS[@]}"; do
cp "$WORKDIR/$_conf.conf" "/etc/dnsmasq.d/$_conf.$_server.conf"
done

sed -i "s|^\(server.*\)/[^/]*$|\1/$_server|" /etc/dnsmasq.d/*."$_server".conf
done

touch /etc/dnsmasq.d/final.conf
echo 'server=/#/127.0.0.1#5353' > /etc/dnsmasq.d/final.conf
echo 'conf-dir=/etc/dnsmasq.d/,*.conf' >> /etc/dnsmasq.conf

echo "Restarting dnsmasq service..."

service dnsmasq restart

echo "Cleaning up..."
rm -r "$WORKDIR"
