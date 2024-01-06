.#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/coolsnowwolf/lede / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic
# svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
# Fix runc version error
# rm -rf ./feeds/packages/utils/runc/Makefile
# svn export https://github.com/openwrt/packages/trunk/utils/runc/Makefile ./feeds/packages/utils/runc/Makefile

# coolsnowwolf default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini}
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# Add third-party software packages (The entire repository)
# git clone https://github.com/libremesh/lime-packages.git package/lime-packages
# Add third-party software packages (Specify the package)
# svn co https://github.com/libremesh/lime-packages/trunk/packages/{shared-state-pirania,pirania-app,pirania} package/lime-packages/packages
# Add to compile options (Add related dependencies according to the requirements of the third-party software package Makefile)
# sed -i "/DEFAULT_PACKAGES/ s/$/ pirania-app pirania ip6tables-mod-nat ipset shared-state-pirania uhttpd-mod-lua/" target/linux/armvirt/Makefile

# Apply patch
# git apply ../config-openwrt/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------

#!/bin/bash

# For OpenWrt 21.02 or lower version
# You have to manually upgrade Golang toolchain to 1.18 or higher to compile Xray-core.
# ./scripts/feeds update packages
# rm -rf feeds/packages/lang/golang
# svn co https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang feeds/packages/lang/golang

# change default lan address and hostname
# verified to be working
sed -i 's/192.168.1.1/192.168.88.2/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/Home/g' package/base-files/files/bin/config_generate
sed -i 's/\+shellsync//' package/network/services/ppp/Makefile
sed -i 's/\+kmod-mppe//' package/network/services/ppp/Makefile
sed -i '281s/y/n/'  config/Config-images.in
sed -i '293s/y/n/'  config/Config-images.in
sed -i '70s/y/n/'  config/Config-images.in
sed -i '80s/y/n/'  config/Config-images.in
sed -i '27s/y/n/'  feeds/luci/applications/luci-app-rclone/Makefile
sed -i '31s/y/n/'  feeds/luci/applications/luci-app-rclone/Makefile
sed -i '29s/y/n/'  feeds/luci/applications/luci-app-unblockmusic/Makefile
# sed -i 's/Dynamic DNS/DDNS/g'  feeds/luci/applications/luci-app-ddns/luasrc/controller/ddns.lua
sed -i 's/KMS Server/KMS/' feeds/luci/applications/luci-app-vlmcsd/luasrc/controller/vlmcsd.lua
# sed -i 's/ACME certs/ACME/' feeds/luci/applications/luci-app-acme/luasrc/controller/acme.lua
# sed -i 's/_("udpxy")/_("IPTV")/' feeds/luci/applications/luci-app-udpxy/luasrc/controller/udpxy.lua 
sed -i 's/default y/default n/g'  feeds/luci/applications/luci-app-turboacc/Makefile
# sed -i '12-15d' feeds/luci/applications/luci-app-acme/po/zh-cn/acme.po
sed -i '1-3d' feeds/luci/applications/luci-app-vlmcsd/po/zh-cn/vlmcsd.po
sed -i '18,29d' package/lean/default-settings/files/zzz-default-settings
sed -i 's/nas/services/g' feeds/luci/applications/luci-app-qbittorrent/luasrc/controller/qbittorrent.lua
sed -i 's/nas/services/g' feeds/luci/applications/luci-app-qbittorrent/luasrc/view/qbittorrent_status.htm
sed -i 's/nas/services/g' feeds/luci/applications/luci-app-nfs/luasrc/controller/nfs.lua
sed -i 's/nas/services/g' feeds/luci/applications/luci-app-samba4/luasrc/controller/samba4.lua
# sed -i '81s/"Libev"/"None"/'  feeds/helloworld/luci-app-ssr-plus/Makefile
# sed -i '142s/"n"/y"/'  feeds/helloworld/luci-app-ssr-plus/Makefile
# sed -i '146s/"y"/n"/'  feeds/helloworld/luci-app-ssr-plus/Makefile
# sed -i '150s/"y"/n` "/'  feeds/helloworld/luci-app-ssr-plus/Makefile
# sed -i 's/"ShadowSocksR Plus+"/"SSRP+"/'  feeds/helloworld/luci-app-ssr-plus/luasrc/controller/shadowsocksr.lua

# remove packages not needed
sed -i -e '56s/dnsmasq-full firewall iptables ppp ppp-mod-pppoe/luci-app-qbittorrent/' include/target.mk
sed -i -e '57s/block-mount coremark kmod-nf-nathelper kmod-nf-nathelper-extra kmod-ipt-raw kmod-tun/luci-app-samba4/' include/target.mk
sed -i -e '58s/iptables-mod-tproxy iptables-mod-extra ipset ip-full default-settings/nano htop curl/' include/target.mk
sed -i -e '59s/ddns-scripts_aliyun ddns-scripts_dnspod luci-app-ddns luci-app-upnp luci-app-autoreboot/nfs-utils kmod-fs-nfs kmod-fs-nfs-v4 kmod-fs-nfs-v3 nfs-kernel-server kmod-loop/' include/target.mk
sed -i -e '60s/luci-app-arpbind luci-app-filetransfer luci-app-vsftpd luci-app-ssr-plus/luci-app-amlogic perl perl-http-date perlbase-file perlbase-getopt perlbase-time perlbase-unicode perlbase-utf8 blkid fdisk lsblk parted attr btrfs-progs chattr dosfstools e2fsprogs f2fs-tools f2fsck lsattr mkf2fs xfs-fsck xfs-mkfs bsdtar bash gawk getopt losetup tar uuidgen/' include/target.mk
sed -i -e '61s/luci-app-accesscontrol luci-app-nlbwmon luci-app-turboacc luci-app-wol curl ca-certificate/luci-app-nfs/' include/target.mk
