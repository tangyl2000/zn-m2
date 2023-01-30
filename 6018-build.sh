#!/bin/bash

#git clone源码
#git clone -b main --single-branch https://github.com/sdf8057/ipq6000.git
#cd ipq6000

#更新packages/luci/routing/telephony
#./scripts/feeds update -a 
#./scripts/feeds install -a

#修改默认主题为agronv3
sed -i 's/luci-theme-bootstrap/luci-theme-argonv3/g' feeds/luci/collections/luci/Makefile
sed -i 's/Bootstrap/Argonv3/g' feeds/luci/collections/luci/Makefile

#修改ethtool版本
rm -rf package/network/utils/ethtool
svn export --force https://github.com/openwrt/openwrt/branches/master/package/network/utils/ethtool package/network/utils/ethtool

#修改6in4版本
rm -rf package/network/ipv6/6in4
svn export --force https://github.com/openwrt/openwrt/branches/master/package/network/ipv6/6in4 package/network/ipv6/6in4

#修改openssl版本
rm -rf package/libs/openssl
svn export --force https://github.com/openwrt/openwrt/branches/master/package/libs/openssl package/libs/openssl

#修改urandom-seed版本
rm -rf package/system/urandom-seed
svn export --force https://github.com/openwrt/openwrt/branches/master/package/system/urandom-seed package/system/urandom-seed

#修改ubox版本
rm -rf package/system/ubox
svn export --force https://github.com/openwrt/openwrt/branches/master/package/system/ubox package/system/ubox

#修改curl版本
rm -rf feeds/packages/net/curl
svn export --force https://github.com/openwrt/packages/branches/master/net/curl feeds/packages/net/curl

#修改nano版本：
rm -rf feeds/packages/utils/nano
svn export --force https://github.com/openwrt/packages/branches/master/utils/nano feeds/packages/utils/nano

#修改node版本：
rm -rf feeds/packages/lang/node
svn export --force https://github.com/coolsnowwolf/packages/branches/master/lang/node feeds/packages/lang/node

#修改ddns-scripts ddns-scripts_aliyun ddns-scripts_dnspod版本
rm -rf feeds/packages/net/{ddns-scripts,ddns-scripts_aliyun,ddns-scripts_dnspod}
svn export --force https://github.com/immortalwrt/packages/branches/master/net/ddns-scripts feeds/packages/net/ddns-scripts
svn export --force https://github.com/immortalwrt/packages/branches/master/net/ddns-scripts_aliyun feeds/packages/net/ddns-scripts_aliyun
svn export --force https://github.com/immortalwrt/packages/branches/master/net/ddns-scripts_dnspod feeds/packages/net/ddns-scripts_dnspod

#下载自己的默认配置
rm -rf .config
#curl -sfL https://raw.githubusercontent.com/tangyl2000/zn-m2/main/config -o .config

#make defconfig
#make defconfig

#make download
#make download -j8

#make
#make -j6 V=s
