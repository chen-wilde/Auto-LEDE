#!/bin/bash
#
# https://github.com/chen-wilde/Actions-OpenWrt
#
# File name: remote.sh
# Description: OpenWrt script for create remote config (Before diy script part 2)
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

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

mkdir -p files/etc/{config,cloudflared}

cat > files/etc/config/tailscale << EOF

config tailscale 'settings'
    option log_stderr '1'
    option log_stdout '1'
    option port '41641'
    option state_file '/etc/tailscale/tailscaled.state'
    option fw_mode 'iptables'
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

echo "$FRPC_CONFIG" > files/etc/config/frpc
echo "$TUNNEL_CONFIG" > files/etc/config/cloudflared
echo "$TUNNEL_CERT" > files/etc/cloudflared/cert.pem
echo "$ZEROTIER_CONFIG" > files/etc/config/zerotier

sed -i "s/\\\$1\\\$[^:]*:0:/$LEDE_PASSWD/g" package/lean/default-settings/files/zzz-default-settings