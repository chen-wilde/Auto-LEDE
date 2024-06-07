# 使用 GitHub Actions 自动编译 OpenWrt 固件

点击 Use this template 来搭建自己的仓库

## Usage

- 通过修改 `REPO_URL` 和 `REPO_BRANCH` 变量自定义 OpenWrt 分支。
- 编辑 deps 文件内容来安装 OpenWrt 分支所需依赖。
- 在仓库根目录上传 `.config` 文件，它记录了编译配置，用于自定义插件和功能，在本地或虚拟机生成。
- `DEVICE` 变量代表设备名，这里用作 tag 的一部分。
- 两个 diy 脚本分别在更新与安装 feeds 的前后执行，把对源码修改脚本放在这里，比如更改默认ip、添加包等。
- 使用 `UPLOAD_ONEDRIVE` 来上传到 OneDrive 网盘，`ONEDRIVE_DIR` 为目标路径。

## Tips

- 创建多个 yml 文件来实现多固件、多分支、多配置同时编译。
- 将 rclone 配置文件保存在仓库 Secrets 并命名为 `RCLONE_CONFIG`，确保 token 不会泄露。
- 在仓库根目录创建 `files` 目录，这个目录映射了固件的系统目录，将需要自定义或者添加的文件放置在此，例如 uhttpd 、firewall 等，实现固件到手即用。
- 为了 `.config` 文件的鲁棒性，尽量只保留有效配置，即在 `make menuconfig` 界面选定的配置，遇到依赖链问题保留最小组件即可。若不确定可以在本地创建配置文件再执行 `make defconfig` 看配置是否还在，在即为有效配置。
- 在 Cache 步骤添加 `mixkey` 密钥允许 workflow 区分缓存。

## Credits

- [P3TERX](https://p3terx.com)
- [OpenWrt](https://github.com/openwrt/openwrt)
- [GitHub Actions](https://github.com/features/actions)
- [Microsoft Azure](https://azure.microsoft.com)
- [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
- [maximize-build-space](https://github.com/easimon/maximize-build-space)
- [stupidloud/cachewrtbuild](https://github.com/stupidloud/cachewrtbuild)
- [softprops/action-gh-release](https://github.com/softprops/action-gh-release)
- [Mattraks/delete-workflow-runs](https://github.com/Mattraks/delete-workflow-runs)
- [peter-evans/repository-dispatch](https://github.com/peter-evans/repository-dispatch)
- [dev-drprasad/delete-older-releases](https://github.com/dev-drprasad/delete-older-releases)

## License

[MIT](https://github.com/chen-wilde/Actions-OpenWrt/blob/main/LICENSE)
