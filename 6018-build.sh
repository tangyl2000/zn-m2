#!/bin/bash

#拉取git clone源码
#git clone -b main --single-branch https://github.com/sdf8057/ipq6000.git
#cd ipq6000

#修改ethtool版本
rm -rf package/network/utils/ethtool
svn export --force https://github.com/openwrt/openwrt/branches/master/package/network/utils/ethtool package/network/utils/ethtool

#修改6in4版本
rm -rf package/network/ipv6/6in4
svn export --force https://github.com/openwrt/openwrt/branches/master/package/network/ipv6/6in4 package/network/ipv6/6in4

#修改openssl版本---官方已改3.0.8，但报错，此处暂用1.1.1t---20230301
rm -rf package/libs/openssl
svn export --force https://github.com/coolsnowwolf/lede/branches/master/package/libs/openssl

#修改urandom-seed版本
rm -rf package/system/urandom-seed
svn export --force https://github.com/openwrt/openwrt/branches/master/package/system/urandom-seed package/system/urandom-seed

#修改ubox版本
rm -rf package/system/ubox
svn export --force https://github.com/openwrt/openwrt/branches/master/package/system/ubox package/system/ubox

#更新ssdk版本，包括qca-ssdk和qca-ssdk-shell
rm -rf package/qca/qca-ssdk-shell
rm -rf package/qca/qca-ssdk
svn export --force https://github.com/hxlls/ipq6000/branches/main/package/qca/nss/qca-ssdk-shell package/qca/qca-ssdk-shell
svn export --force https://github.com/hxlls/ipq6000/branches/main/package/qca/nss/qca-ssdk package/qca/qca-ssdk

#更新ipv6-helper版本
rm -rf package/addition/ipv6-helper
svn export --force https://github.com/hxlls/ipq6000/branches/main/package/addition/ipv6-helper package/addition/ipv6-helper

#更新packages/luci/routing/telephony
./scripts/feeds update -a && ./scripts/feeds install -a

#修改默认主题为agronv3
sed -i 's/luci-theme-bootstrap/luci-theme-argonv3/g' feeds/luci/collections/luci/Makefile
sed -i 's/Bootstrap/Argonv3/g' feeds/luci/collections/luci/Makefile

#更新passwall所有依赖包
rm -rf feeds/packages/net/brook
rm -rf feeds/packages/net/chinadns-ng
rm -rf feeds/packages/net/dns2socks
rm -rf feeds/packages/net/dns2tcp
rm -rf feeds/packages/net/hysteria
rm -rf feeds/packages/net/ipt2socks
rm -rf feeds/packages/net/pdnsd-alt
rm -rf feeds/packages/net/shadowsocksr-libev
rm -rf feeds/packages/net/shadowsocks-rust
rm -rf feeds/packages/net/simple-obfs
rm -rf feeds/packages/net/ssocks
rm -rf feeds/packages/net/trojan
rm -rf feeds/packages/net/trojan-go
rm -rf feeds/packages/net/trojan-plus
rm -rf feeds/packages/net/v2raya
rm -rf feeds/packages/net/v2ray-core
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/v2ray-plugin
rm -rf feeds/packages/net/xray-core
rm -rf feeds/packages/net/xray-plugin
git clone https://github.com/kenzok8/small
mv small/* feeds/packages/net/
rm -rf feeds/packages/net/README.md
rm -rf small
rm -rf feeds/luci/applications/luci-app-passwall
svn export --force https://github.com/kenzok8/openwrt-packages/branches/master/luci-app-passwall feeds/luci/applications/luci-app-passwall

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

#修改ddns-scripts版本，貌似2.8.2显示不出服务提供商，2.7.8才正常。需要尝试kenzok8/openwrt-packages的luci-app-aliddns
#rm -rf feeds/packages/net/{ddns-scripts,ddns-scripts_aliyun,ddns-scripts_dnspod}
#rm -rf feeds/packages/net/ddns-scripts
#svn export --force https://github.com/immortalwrt/packages/branches/master/net/ddns-scripts feeds/packages/net/ddns-scripts
#svn export --force https://github.com/immortalwrt/packages/branches/master/net/ddns-scripts_aliyun feeds/packages/net/ddns-scripts_aliyun
#svn export --force https://github.com/immortalwrt/packages/branches/master/net/ddns-scripts_dnspod feeds/packages/net/ddns-scripts_dnspod

#获取luci-app-aliddns
rm -rf feeds/luci/applications/luci-app-aliddns
svn export --force https://github.com/kenzok8/openwrt-packages/branches/master/luci-app-aliddns feeds/luci/applications/luci-app-aliddns

#修改mosdns版本、获取luci-app-mosdns
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns
svn export --force https://github.com/kenzok8/openwrt-packages/branches/master/mosdns feeds/packages/net/mosdns
svn export --force https://github.com/kenzok8/openwrt-packages/branches/master/luci-app-mosdns feeds/luci/applications/luci-app-mosdns

#获取luci-app-adguardhome、adguardhome
rm -rf feeds/packages/net/adguardhome
rm -rf feeds/luci/applications/luci-app-adguardhome
svn export --force https://github.com/kenzok8/openwrt-packages/branches/master/adguardhome feeds/packages/net/adguardhome
svn export --force https://github.com/kenzok8/openwrt-packages/branches/master/luci-app-adguardhome feeds/luci/applications/luci-app-adguardhome

#获取luci-app-pushbot
rm -rf feeds/luci/applications/luci-app-pushbot
svn export --force https://github.com/kenzok8/openwrt-packages/branches/master/luci-app-pushbot feeds/luci/applications/luci-app-pushbot

#获取mosdns报错的upx
svn export --force https://github.com/kuoruan/openwrt-upx/branches/master/upx package/utils/upx
svn export --force https://github.com/kuoruan/openwrt-upx/branches/master/ucl package/utils/ucl

#获取ucode,zerotier-1.10.2的依赖包，报错了~~~20230301
rm -rf package/utils/ucode
svn export --force https://github.com/immortalwrt/immortalwrt/branches/master/package/utils/ucode package/utils/ucode

#获取zerotier
rm -rf feeds/packages/net/zerotier
svn export --force https://github.com/immortalwrt/packages/branches/master/net/zerotier feeds/packages/net/zerotier
rm -rf feeds/luci/applications/luci-app-zerotier
svn export --force https://github.com/immortalwrt/luci/branches/master/applications/luci-app-zerotier feeds/luci/applications/luci-app-zerotier

rm -rf ./tmp

#更新luci和packages
./scripts/feeds update -i packages
./scripts/feeds install -a -p packages
./scripts/feeds update -i luci
./scripts/feeds install -a -p luci

#下载自己的默认配置
rm -rf .config
#curl -sfL https://raw.githubusercontent.com/tangyl2000/zn-m2/main/zn-m2-config-pw -o .config

#修改.config, 启用mosdns-v5包，禁用相隔一行的mosdns-v4。删除luci-app-mosdns编译配置文件中的mosdns依赖，否则报错。

#make defconfig
#make defconfig

#make download
#make download -j8

#make
#make -j6 V=s
