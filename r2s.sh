#!/bin/bash
#
# https://github.com/chen-wilde/Auto-LEDE
#
# File name: r2s.sh
# Description: OpenWrt script for create remote config (Before diy script part 2)
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

mkdir -p files/etc/{config,cloudflared}
echo "$ACME_CONFIG" > files/etc/config/acme
echo "$DDNS_CONFIG" > files/etc/config/ddns
echo "$TUNNEL_CERT" > files/etc/cloudflared/cert.pem

sed -i "s/enabled '0'/enabled '1'/" feeds/luci/applications/luci-app-tailscale/root/etc/config/tailscale
sed -i "s/enabled '0'/enabled '1'/;s/token ''/token '$TUNR2S_TOKEN'/" feeds/packages/net/cloudflared/files/cloudflared.config

api_request=$(curl -d "client_id=$CLIENT_ID" -d "client_secret=$CLIENT_SECRET" \
    "https://api.tailscale.com/api/v2/oauth/token")
access_token=$(echo $api_request | jq -r '.access_token')

key_request=$(curl 'https://api.tailscale.com/api/v2/tailnet/-/keys' \
  --request POST \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $access_token" \
  --data '{
  "capabilities": {
    "devices": {
      "create": {
        "preauthorized": true,
        "tags": [
          "tag:lede"
        ]
      }
    }
  },
  "expirySeconds": 864000
}')
auth_key=$(echo $key_request | jq -r '.key')

cat >> feeds/luci/applications/luci-app-tailscale/root/etc/config/tailscale << EOF
	option accept_routes '0'
	option advertise_exit_node '0'
	list access 'ts_ac_lan'
	list access 'ts_ac_wan'
	list access 'lan_ac_ts'
	list flags '--auth-key=$auth_key'
EOF

cd package
#cat >> network/config/firewall/files/firewall.config << EOF

#config redirect
#	option name		https
#	option src		wan
#	option src_dport	1443
#	option dest		lan
#	option dest_ip		192.168.1.1
#	option dest_port	443
#	option target		DNAT
#EOF

sed -i 's/-dhcp/-pppoe/' base-files/files/lib/functions/uci-defaults.sh
sed -i "s/'username'/'$PPPOE_USER'/;s/'password'/'006688'/" base-files/files/bin/config_generate
sed -i "s/\\\$1\\\$[^:]*:0:/$LEDE_PASSWD/g" lean/default-settings/files/zzz-default-settings