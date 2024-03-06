#!/bin/bash

#拉取git clone源码
git clone -b main --single-branch https://github.com/breeze303/ipq6000-6.1-nss.git

#二次编译
git fetch && git reset --hard origin/main

#进入编译路径
cd ipq6000-6.1-nss

#更新packages/luci/routing/telephony
./scripts/feeds update -a 
./scripts/feeds install -a

#更新agronv3主题
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b master https://github.com/jerrykuku/luci-theme-argon feeds/luci/themes/luci-theme-argon

#更新passwall所有依赖包和luci
rm -rf feeds/packages/net/{brook,chinadns-ng,dns2socks,dns2tcp,gn,hysteria,ipt2socks,microsocks,naiveproxy,pdnsd-alt,redsocks2,shadow-tls,shadowsocks-rust,shadowsocksr-libev,simple-obfs,sing-box,ssocks,tcping,trojan-go,trojan-plus,trojan,tuic-client,v2dat,v2ray-core,v2ray-geodata,v2ray-plugin,v2raya,xray-core,xray-plugin,mosdns}
git clone https://github.com/kenzok8/small
rm -rf feeds/packages/net/luci-app-mosdns
mv small/* feeds/packages/net/
rm -rf small
rm -rf feeds/packages/net/README.md
rm -rf feeds/packages/net/LICENSE
rm -rf feeds/packages/lang/lua-neturl
mv feeds/packages/net/lua-neturl feeds/packages/lang/lua-neturl
rm -rf feeds/luci/applications/{luci-app-bypass,luci-app-passwall,luci-app-passwall2,luci-app-ssr-plus,luci-app-mosdns}
mv feeds/packages/net/luci-app-bypass feeds/luci/applications/luci-app-bypass
mv feeds/packages/net/luci-app-passwall feeds/luci/applications/luci-app-passwall
mv feeds/packages/net/luci-app-passwall2 feeds/luci/applications/luci-app-passwall2
mv feeds/packages/net/luci-app-ssr-plus feeds/luci/applications/luci-app-ssr-plus
mv feeds/packages/net/luci-app-mosdns feeds/luci/applications/luci-app-mosdns

#更新ddns-go
rm -rf feeds/packages/net/ddns-go
rm -rf feeds/luci/applications/luci-app-ddns-go
git clone https://github.com/sirpdboy/luci-app-ddns-go
mv luci-app-ddns-go/luci-app-ddns-go feeds/luci/applications/luci-app-ddns-go
mv luci-app-ddns-go/ddns-go feeds/packages/net/ddns-go
rm -rf luci-app-ddns-go

#获取luci-app-pushbot---暂时不用了
rm -rf feeds/luci/applications/luci-app-pushbot
svn export --force https://github.com/coolsnowwolf/luci/branches/master/applications/luci-app-pushbot feeds/luci/applications/luci-app-pushbot

#获取watchcat和luci
rm -rf feeds/packages/net/watchcat
svn export --force https://github.com/kenzok8/small-package/branches/main/watchcat feeds/packages/net/watchcat
rm -rf feeds/luci/applications/luci-app-watchcat
svn export --force https://github.com/kenzok8/small-package/branches/main/luci-app-watchcat feeds/luci/applications/luci-app-watchcat

#获取zerotier
rm -rf feeds/packages/net/zerotier
svn export --force https://github.com/coolsnowwolf/packages/branches/master/net/zerotier feeds/packages/net/zerotier
rm -rf feeds/luci/applications/luci-app-zerotier
svn export --force https://github.com/coolsnowwolf/luci/branches/master/applications/luci-app-zerotier feeds/luci/applications/luci-app-zerotier

#修改mosdns版本、获取luci-app-mosdns
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns
svn export --force https://github.com/kenzok8/openwrt-packages/branches/master/mosdns feeds/packages/net/mosdns
svn export --force https://github.com/kenzok8/openwrt-packages/branches/master/luci-app-mosdns feeds/luci/applications/luci-app-mosdns

#获取msd_lite和luci-app-msd_lite
rm -rf feeds/packages/net/msd_lite
git clone https://github.com/ximiTech/msd_lite feeds/packages/net/msd_lite
rm -rf feeds/luci/applications/luci-app-msd_lite
git clone https://github.com/ximiTech/luci-app-msd_lite feeds/luci/applications/luci-app-msd_lite

#更新luci-app-dnsfilter
rm -rf feeds/luci/applications/luci-app-dnsfilter
git clone https://github.com/kiddin9/luci-app-dnsfilter feeds/luci/applications/luci-app-dnsfilter


rm -rf ./tmp

#更新luci和packages
./scripts/feeds update -i packages
./scripts/feeds install -a -p packages
./scripts/feeds update -i luci
./scripts/feeds install -a -p luci

make menuconfig
make defconfig

make download -j8

make -j8 V=s
