#!/bin/bash
#
# https://github.com/chen-wilde/Actions-OpenWrt
#
# File name: r2s.sh
# Description: OpenWrt script for create remote config (Before diy script part 2)
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

mkdir -p files/etc/config
echo "$ACME_CONFIG" > files/etc/config/acme
echo "$DDNS_CONFIG" > files/etc/config/ddns

cd package
cat >> network/config/firewall/files/firewall.config << EOF

config redirect
	option name		https
	option src		wan
	option src_dport	1443
	option dest			lan
	option dest_ip		192.168.1.1
	option dest_port	443
	option target		DNAT
EOF

sed -i 's/-dhcp/-pppoe/g' base-files/luci2/lib/functions/uci-defaults.sh
sed -i "s/'username'/'$PPPOE_USER'/g;s/'password'/'006688'/g" base-files/luci2/bin/config_generate
sed -i "s/\\\$1\\\$[^:]*:0:/$LEDE_PASSWD/g" lean/default-settings/files/zzz-default-settings