#!/bin/bash

#拉取git clone源码
git clone -b main --single-branch https://github.com/sdf8057/ipq6000.git

#二次编译
git fetch && git reset --hard origin/main

#进入编译路径
cd ipq6000

#修改ethtool版本---20231008-6.4和6.5报错，需用6.3
rm -rf package/network/utils/ethtool
svn export --force https://github.com/openwrt/openwrt/branches/master/package/network/utils/ethtool package/network/utils/ethtool

#修改6in4版本
rm -rf package/network/ipv6/6in4
svn export --force https://github.com/openwrt/openwrt/branches/master/package/network/ipv6/6in4 package/network/ipv6/6in4

#修改urandom-seed版本
rm -rf package/system/urandom-seed
svn export --force https://github.com/openwrt/openwrt/branches/master/package/system/urandom-seed package/system/urandom-seed

#修改ubox版本
rm -rf package/system/ubox
svn export --force https://github.com/openwrt/openwrt/branches/master/package/system/ubox package/system/ubox

#修改ubus版本
rm -rf package/system/ubus
svn export --force https://github.com/openwrt/openwrt/branches/master/package/system/ubus package/system/ubus
#用op官网ubus版本，必须要修改rpcd的配置文件(package/system/rpcd/files/rpcd.config)中ubus.sock文件路径为：/var/run/ubus/ubus.sock，原路径：/var/run/ubus.sock

#修改rpcd版本
rm -rf package/system/rpcd
svn export --force https://github.com/openwrt/openwrt/branches/openwrt-21.02/package/system/rpcd package/system/rpcd/

#更新ssdk版本，包括qca-ssdk和qca-ssdk-shell
rm -rf package/qca
svn export --force https://github.com/hxlls/ipq6000/branches/main/package/qca package/qca

#更新ipv6-helper版本
rm -rf package/extra/ipv6-helper
svn export --force https://github.com/hxlls/ipq6000/branches/main/package/addition/ipv6-helper package/extra/ipv6-helper

#更新openssl版本---目前1.1.1t，暂不更新
rm -rf package/libs/openssl
svn export --force https://github.com/hxlls/ipq6000/branches/main/package/libs/openssl package/libs/openssl

#更新firewall版本
rm -rf package/network/config/firewall
svn export --force https://github.com/hxlls/ipq6000/branches/main/package/network/config/firewall package/network/config/firewall

#更新dnsmasq-full版本
rm -rf package/network/services/dnsmasq
svn export --force https://github.com/hxlls/ipq6000/branches/main/package/network/services/dnsmasq package/network/services/dnsmasq

#更新openwrt-keyring版本
rm -rf package/system/openwrt-keyring
svn export --force https://github.com/hxlls/ipq6000/branches/main/package/system/openwrt-keyring package/system/openwrt-keyring

#更新ip-full(iproute2)版本
rm -rf package/network/utils/iproute2
svn export --force https://github.com/hxlls/ipq6000/branches/main/package/network/utils/iproute2 package/network/utils/iproute2

#更新busybox版本
rm -rf package/utils/busybox
svn export --force https://github.com/hxlls/ipq6000/branches/main/package/utils/busybox package/utils/busybox

#更新packages/luci/routing/telephony
./scripts/feeds update -a && ./scripts/feeds install -a


#更新agronv3主题
rm -rf feeds/luci/themes/luci-theme-argonv3
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon feeds/luci/themes/luci-theme-argonv3

#修改默认主题为agronv3
sed -i 's/luci-theme-bootstrap/luci-theme-argonv3/g' feeds/luci/collections/luci/Makefile
sed -i 's/Bootstrap/Argonv3/g' feeds/luci/collections/luci/Makefile

#更新passwall所有依赖包和luci
rm -rf feeds/packages/net/{brook,chinadns-ng,dns2socks,dns2tcp,gn,hysteria,ipt2socks,microsocks,naiveproxy,pdnsd-alt,shadowsocks-rust,shadowsocksr-libev,simple-obfs,sing-box,ssocks,tcping,trojan-go,trojan-plus,trojan,v2ray-core,v2ray-geodata,v2ray-plugin,xray-core,xray-plugin,tuic-client,redsocks2,v2raya}
git clone https://github.com/kenzok8/small
mv small/* feeds/packages/net/
rm -rf small
rm -rf feeds/packages/net/README.md
rm -rf feeds/packages/net/LICENSE
rm -rf feeds/packages/lang/lua-neturl
mv feeds/packages/net/lua-neturl feeds/packages/lang/lua-neturl
rm -rf feeds/luci/applications/{luci-app-bypass,luci-app-passwall,luci-app-passwall2,luci-app-ssr-plus,luci-app-vssr}
mv feeds/packages/net/luci-app-bypass feeds/luci/applications/luci-app-bypass
mv feeds/packages/net/luci-app-passwall feeds/luci/applications/luci-app-passwall
mv feeds/packages/net/luci-app-passwall2 feeds/luci/applications/luci-app-passwall2
mv feeds/packages/net/luci-app-ssr-plus feeds/luci/applications/luci-app-ssr-plus
mv feeds/packages/net/luci-app-vssr feeds/luci/applications/luci-app-vssr

#修改curl版本
rm -rf feeds/packages/net/curl
svn export --force https://github.com/openwrt/packages/branches/master/net/curl feeds/packages/net/curl

#修改nano版本：
rm -rf feeds/packages/utils/nano
svn export --force https://github.com/openwrt/packages/branches/master/utils/nano feeds/packages/utils/nano

#修改node版本：
rm -rf feeds/packages/lang/node
svn export --force https://github.com/coolsnowwolf/packages/branches/master/lang/node feeds/packages/lang/node

#修改golang版本---mosdns-v5需要新版golang
rm -rf feeds/packages/lang/golang
svn export --force https://github.com/openwrt/packages/branches/master/lang/golang feeds/packages/lang/golang

#修改htop版本
rm -rf feeds/packages/admin/htop
svn export --force https://github.com/immortalwrt/packages/branches/master/admin/htop feeds/packages/admin/htop

#修改ddns-scripts版本，貌似2.8.2显示不出服务提供商，2.7.8才正常。需要尝试kenzok8/openwrt-packages的luci-app-aliddns
#rm -rf feeds/packages/net/{ddns-scripts,ddns-scripts_aliyun,ddns-scripts_dnspod}
#rm -rf feeds/packages/net/ddns-scripts
#svn export --force https://github.com/immortalwrt/packages/branches/master/net/ddns-scripts feeds/packages/net/ddns-scripts
#svn export --force https://github.com/immortalwrt/packages/branches/master/net/ddns-scripts_aliyun feeds/packages/net/ddns-scripts_aliyun
#svn export --force https://github.com/immortalwrt/packages/branches/master/net/ddns-scripts_dnspod feeds/packages/net/ddns-scripts_dnspod

#更新ddns-go
rm -rf feeds/packages/net/ddns-go
svn export --force https://github.com/sirpdboy/luci-app-ddns-go/branches/main/ddns-go feeds/packages/net/ddns-go
rm -rf feeds/luci/applications/luci-app-ddns-go
svn export --force https://github.com/sirpdboy/luci-app-ddns-go/branches/main/luci-app-ddns-go feeds/luci/applications/luci-app-ddns-go

#修改mosdns版本、获取luci-app-mosdns
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns
svn export --force https://github.com/kenzok8/openwrt-packages/branches/master/mosdns feeds/packages/net/mosdns
svn export --force https://github.com/kenzok8/openwrt-packages/branches/master/luci-app-mosdns feeds/luci/applications/luci-app-mosdns

#获取v2dat,luci-app-mosdns依赖于此
rm -rf feeds/packages/utils/v2dat
svn export --force https://github.com/coolsnowwolf/packages/branches/master/utils/v2dat feeds/packages/utils/v2dat

#获取luci-app-adguardhome、adguardhome
rm -rf feeds/packages/net/adguardhome
svn export --force https://github.com/kenzok8/openwrt-packages/branches/master/adguardhome feeds/packages/net/adguardhome
rm -rf feeds/luci/applications/luci-app-adguardhome
svn export --force https://github.com/kenzok8/openwrt-packages/branches/master/luci-app-adguardhome feeds/luci/applications/luci-app-adguardhome

#获取luci-app-pushbot
rm -rf feeds/luci/applications/luci-app-pushbot
svn export --force https://github.com/coolsnowwolf/luci/branches/master/applications/luci-app-pushbot feeds/luci/applications/luci-app-pushbot

#获取zerotier
rm -rf feeds/packages/net/zerotier
git clone https://github.com/mwarning/zerotier-openwrt
mv zerotier-openwrt/zerotier/ feeds/packages/net/zerotier
rm -rf zerotier-openwrt/
rm -rf feeds/luci/applications/luci-app-zerotier
git clone https://github.com/zhengmz/luci-app-zerotier feeds/luci/applications/luci-app-zerotier

#获取msd_lite和luci-app-msd_lite
rm -rf feeds/packages/net/msd_lite
git clone https://github.com/ximiTech/msd_lite feeds/packages/net/msd_lite
rm -rf feeds/luci/applications/luci-app-msd_lite
git clone https://github.com/ximiTech/luci-app-msd_lite feeds/luci/applications/luci-app-msd_lite

#更新unblockmusic
rm -rf feeds/packages/multimedia/UnblockNeteaseMusic
svn export --force https://github.com/kenzok8/small-package/branches/main/UnblockNeteaseMusic feeds/packages/multimedia/UnblockNeteaseMusic
rm -rf feeds/packages/multimedia/UnblockNeteaseMusic-Go
svn export --force https://github.com/kenzok8/small-package/branches/main/UnblockNeteaseMusic-Go feeds/packages/multimedia/UnblockNeteaseMusic-Go
rm -rf feeds/luci/applications/luci-app-unblockmusic
svn export --force https://github.com/coolsnowwolf/luci/branches/master/applications/luci-app-unblockmusic feeds/luci/applications/luci-app-unblockmusic
rm -rf feeds/packages/utils/upx
svn export --force https://github.com/immortalwrt/packages/branches/master/utils/upx feeds/packages/utils/upx

#更新luci-app-dnsfilter
rm -rf feeds/luci/applications/luci-app-dnsfilter
git clone https://github.com/kiddin9/luci-app-dnsfilter feeds/luci/applications/luci-app-dnsfilter


rm -rf ./tmp

#更新luci和packages
./scripts/feeds update -i packages
./scripts/feeds install -a -p packages
./scripts/feeds update -i luci
./scripts/feeds install -a -p luci

#下载自己的默认配置
rm -rf .config
curl -sfL https://raw.githubusercontent.com/tangyl2000/zn-m2/main/zn-m2-config-pw -o .config

make menuconfig
make defconfig

make download -j8

make -j8 V=s
