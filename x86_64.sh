#!/bin/bash
#
# https://github.com/chen-wilde/Auto-LEDE
#
# File name: x86_64.sh
# Description: OpenWrt script for create remote config (Before diy script part 2)
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

mkdir -p files/etc/{config,cloudflared}
echo "$FRPC_CONFIG" > files/etc/config/frpc
echo "$TUNNEL_CERT" > files/etc/cloudflared/cert.pem
echo "$ZTIER_CONFIG" > files/etc/config/zerotier

sed -i "s/\\\$1\\\$[^:]*:0:/$LEDE_PASSWD/g" package/lean/default-settings/files/zzz-default-settings

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

cd feeds
cat >> luci/applications/luci-app-tailscale/root/etc/config/tailscale << EOF
	option accept_routes '0'
	option advertise_exit_node '0'
	list access 'ts_ac_lan'
	list access 'ts_ac_wan'
	list access 'lan_ac_ts'
	list flags '--auth-key=$auth_key'
EOF

sed -i "s/enabled '0'/enabled '1'/" luci/applications/luci-app-tailscale/root/etc/config/tailscale
sed -i "s/enabled '0'/enabled '1'/;s/token ''/token '$TUNX86_TOKEN'/" packages/net/cloudflared/files/cloudflared.config