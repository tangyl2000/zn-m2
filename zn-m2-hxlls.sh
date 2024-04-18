#!/bin/bash

#拉取git clone源码
git clone -b main --single-branch https://github.com/hxlls/ipq6000.git

#二次编译
git fetch && git reset --hard origin/main

#进入编译路径
cd ipq6000

#修改ethtool版本---20231008-6.4和6.5报错，6.6正常编译
rm -rf package/network/utils/ethtool
svn export --force https://github.com/openwrt/openwrt/branches/master/package/network/utils/ethtool package/network/utils/ethtool

#修改6in4版本
rm -rf package/network/ipv6/6in4
svn export --force https://github.com/openwrt/openwrt/branches/master/package/network/ipv6/6in4 package/network/ipv6/6in4

#修改urandom-seed版本
rm -rf package/system/urandom-seed
svn export --force https://github.com/openwrt/openwrt/branches/master/package/system/urandom-seed package/system/urandom-seed

#修改ubox版本---要用20220813
rm -rf package/system/ubox
svn export --force https://github.com/openwrt/openwrt/branches/master/package/system/ubox package/system/ubox

#修改ubus版本
rm -rf package/system/ubus
svn export --force https://github.com/openwrt/openwrt/branches/master/package/system/ubus package/system/ubus
#用op官网ubus版本，必须要修改rpcd的配置文件(package/system/rpcd/files/rpcd.config)中ubus.sock文件路径为：/var/run/ubus/ubus.sock，原路径：/var/run/ubus.sock

#修改rpcd版本，注意：需要21.02版本的rpcd！！！
rm -rf package/system/rpcd
svn export --force https://github.com/openwrt/openwrt/branches/openwrt-21.02/package/system/rpcd package/system/rpcd/

#更新packages/luci/routing/telephony
./scripts/feeds update -a && ./scripts/feeds install -a


#更新agronv3主题
rm -rf feeds/luci/themes/luci-theme-argonv3
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon feeds/luci/themes/luci-theme-argonv3

#修改默认主题为agronv3
sed -i 's/luci-theme-bootstrap/luci-theme-argonv3/g' feeds/luci/collections/luci/Makefile
sed -i 's/Bootstrap/Argonv3/g' feeds/luci/collections/luci/Makefile

#拉取sdf8057的luci-app-cpufreq
rm -rf feeds/luci/applications/luci-app-cpufreq
svn export --force https://github.com/sdf8057/luci/branches/1806/applications/luci-app-cpufreq feeds/luci/applications/luci-app-cpufreq

#更新passwall所有依赖包和luci，注意：shadowsocksr-libev不能更新，需要用2.5.6-9版本(或immmortal-packages/net中的)！！！
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
#千万注意：如果编译时提示../init.d/sing-box 777和字符等错误，记得要把sing-box.init文件编码转换为utf8格式！！！

#修改curl版本
#rm -rf feeds/packages/net/curl
#svn export --force https://github.com/openwrt/packages/branches/master/net/curl feeds/packages/net/curl
git clone https://github.com/sbwml/package_libs_nghttp3 package/libs/nghttp3
git clone https://github.com/sbwml/package_libs_ngtcp2 package/libs/ngtcp2
rm -rf feeds/packages/net/curl
git clone https://github.com/sbwml/feeds_packages_net_curl feeds/packages/net/curl

#修改nano版本：
rm -rf feeds/packages/utils/nano
svn export --force https://github.com/openwrt/packages/branches/master/utils/nano feeds/packages/utils/nano

#修改node版本：
rm -rf feeds/packages/lang/node
svn export --force https://github.com/coolsnowwolf/packages/branches/master/lang/node feeds/packages/lang/node

#修改golang版本
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

#修改htop版本
rm -rf feeds/packages/admin/htop
svn export --force https://github.com/immortalwrt/packages/branches/master/admin/htop feeds/packages/admin/htop

#更新ddns-go
rm -rf feeds/packages/net/ddns-go
rm -rf feeds/luci/applications/luci-app-ddns-go
git clone https://github.com/sirpdboy/luci-app-ddns-go
mv luci-app-ddns-go/luci-app-ddns-go feeds/luci/applications/luci-app-ddns-go
mv luci-app-ddns-go/ddns-go feeds/packages/net/ddns-go
rm -rf luci-app-ddns-go

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
#git clone https://github.com/mwarning/zerotier-openwrt --此处版本为1.12.1，旧
svn export --force https://github.com/coolsnowwolf/packages/branches/master/net/zerotier feeds/packages/net/zerotier
#mv zerotier-openwrt/zerotier/ feeds/packages/net/zerotier
#rm -rf zerotier-openwrt/
rm -rf feeds/luci/applications/luci-app-zerotier
#git clone https://github.com/zhengmz/luci-app-zerotier feeds/luci/applications/luci-app-zerotier
svn export --force https://github.com/coolsnowwolf/luci/branches/master/applications/luci-app-zerotier feeds/luci/applications/luci-app-zerotier
#svn export --force https://github.com/immortalwrt/immortalwrt/branches/master/package/utils/ucode package/utils/ucode

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
curl -sfL https://raw.githubusercontent.com/tangyl2000/zn-m2/main/zn-m2-config-hxlls -o .config

make menuconfig
make defconfig

make download -j8

make -j8 V=s
