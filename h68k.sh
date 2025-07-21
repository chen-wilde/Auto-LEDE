#!/bin/bash
#
# https://github.com/chen-wilde/Actions-OpenWrt
#
# File name: h68k.sh
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

key_request=$(curl --request POST \
    --url 'https://api.tailscale.com/api/v2/tailnet/-/keys?all=true' \
    --header "Authorization: Bearer $access_token" \
    --header 'Content-Type: application/json' \
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
    "expirySeconds": 864000,
    "description": "actions"
}')
auth_key=$(echo $key_request | jq -r '.key')

cd feeds/packages/net
cat >> tailscale/files/tailscale.conf << EOF
    option enabled '1'
    option config_path '/etc/tailscale'
    option acceptRoutes '0'
    option acceptDNS '1'
    option advertiseExitNode '0'
    list access 'tsfwlan'
    list access 'tsfwwan'
    list access 'lanfwts'
    list flags '--auth-key=$auth_key'
EOF

sed -i "s/enabled '0'/enabled '1'/;s/token ''/token '$TUNNEL_TOKEN'/" cloudflared/files/cloudflared.config