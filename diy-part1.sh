#!/bin/bash
#
# https://github.com/chen-wilde/Actions-OpenWrt
#
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

git revert f0ab317249c09032fd78ecf2216b1fdde825630f

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
 sed -i '$a src-git smpackage https://github.com/kenzok8/small-package' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
