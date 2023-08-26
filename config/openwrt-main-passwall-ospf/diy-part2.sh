
# Add package needed
sed -i -e '59s/ddns-scripts_aliyun ddns-scripts_dnspod luci-app-ddns luci-app-upnp luci-app-autoreboot/luci-app-wireguard luci-proto-wireguard wireguard-tools kmod-wireguard luci-app-qbittorrent luci-app-cifs-mount luci-app-samba4 nano htop curl/'  include/target.mk
# Add nfs/emmc/upgrade
sed -i -e '60s/luci-app-arpbind luci-app-filetransfer luci-app-vsftpd luci-app-ssr-plus luci-app-vlmcsd/luci-app-passwall nfs-utils kmod-fs-nfs kmod-fs-nfs-v4 kmod-fs-nfs-v3 nfs-kernel-server kmod-loop luci-app-amlogic perl perl-http-date perlbase-file perlbase-getopt perlbase-time perlbase-unicode perlbase-utf8 blkid fdisk lsblk parted attr btrfs-progs chattr dosfstools e2fsprogs f2fs-tools f2fsck lsattr mkf2fs xfs-fsck xfs-mkfs bsdtar bash gawk getopt losetup tar uuidgen /' include/target.mk
# Add ospf
sed -i -e '61s/luci-app-accesscontrol luci-app-nlbwmon luci-app-turboacc luci-app-wol curl ca-certificates/bird1c-ipv4 bird1cl-ipv4 git git-gitweb git-http luci-app-bird1-ipv4 make python3/' include/target.mk


#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: main
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='official'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# remove v2ray-geodata package from feeds (openwrt-22.03 & master)
rm -rf feeds/packages/net/v2ray-geodata

git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

rm -rf feeds/packages/lang/golang
svn co https://github.com/openwrt/packages/branches/openwrt-23.05/lang/golang feeds/packages/lang/golang

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
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------


sed -i 's/192.168.1.1/192.168.88.2/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/Home/g' package/base-files/files/bin/config_generate
sed -i -e '56s/dnsmasq/luci-app-passwall luci-compat bird1c-ipv4 bird1cl-ipv4 git git-gitweb git-http luci-app-bird1-ipv4 make python3 dnsmasq-full luci-app-wireguard luci-proto-wireguard wireguard-tools kmod-wireguard perl perl-http-date perlbase-file perlbase-getopt perlbase-time perlbase-unicode perlbase-utf8 blkid fdisk lsblk parted attr btrfs-progs chattr dosfstools e2fsprogs f2fs-tools f2fsck lsattr mkf2fs xfs-fsck xfs-mkfs bsdtar bash gawk getopt losetup tar uuidgen luci-app-amlogic/' include/target.mk