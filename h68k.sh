#!/bin/bash
#
# https://github.com/chen-wilde/Auto-LEDE
#
# File name: h68k.sh
# Description: OpenWrt script for create remote config (Before diy script part 2)
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

sed -i 's/\${defaults ? 0 : 1}/0/g' package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc