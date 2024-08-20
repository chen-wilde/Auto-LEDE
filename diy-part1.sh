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

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
 sed -i '$a src-git smpackage https://github.com/kenzok8/small-package' feeds.conf.default
 sed -i '/^UBOOT_TARGETS := rk3528-evb rk3588-evb/ s/^/#/' package/boot/uboot-rk35xx/Makefile

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
