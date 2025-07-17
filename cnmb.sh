#!/bin/bash

echo "========== 初始化配置开始 =========="

# 设置 root 密码
echo root:'MHTmht123@' | sudo chpasswd root

# 修改 SSH 配置以允许 root 密码登录
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo rm -rf /etc/ssh/sshd_config.d
sudo systemctl restart sshd

# 设置时区为上海
timedatectl set-timezone Asia/Shanghai
sleep 3
# 关闭 systemd-resolved 并修改 DNS
systemctl stop systemd-resolved && systemctl disable systemd-resolved
rm -rf /etc/resolv.conf && echo 'nameserver 8.8.8.8' > /etc/resolv.conf
sleep 3
# 安装并运行 nyanpass 客户端
S=nyanpass OPTIMIZE=1 bash <(curl -fLSs https://dl.nyafw.com/download/nyanpass-install.sh) rel_nodeclient "-o -t 81c0a326-cb00-47f6-80b7-19a1292d0f96 -u https://nbny.laoxiechuanmei.icu"


# 安装并运行 nyanpass 客户端2
S=nyanpass2 bash <(curl -fLSs https://dl.nyafw.com/download/nyanpass-install.sh) rel_nodeclient "-t 6a6bd450-6482-44a8-bf7c-9efc8e9e0003 -u https://nbny.laoxiechuanmei.icu"



# 安装 XrayR
wget -N https://raw.githubusercontent.com/wyx2685/XrayR-release/master/install.sh && bash install.sh

sleep 5

# 覆盖 rulelist 和配置
wget https://raw.githubusercontent.com/laoxiechuzheng/shen-jishenji/main/LICENSE.md -O /etc/XrayR/rulelist
wget https://raw.githubusercontent.com/laoxiechuzheng/xrayr-1/refs/heads/main/config.yml -O /etc/XrayR/config.yml


# 获取证书
mkdir -p /etc/XrayR/cert/certificates

wget -O /etc/XrayR/cert/certificates/cdn2.staticedgecdn.com.crt "https://raw.githubusercontent.com/laoxiechuzheng/xrayr-1/refs/heads/main/certificates/cdn2.staticedgecdn.com.crt"

wget -O /etc/XrayR/cert/certificates/cdn2.staticedgecdn.com.key "https://raw.githubusercontent.com/laoxiechuzheng/xrayr-1/refs/heads/main/certificates/cdn2.staticedgecdn.com.key"

# 启动 XrayR
sudo systemctl start XrayR.service


xrayr restart
sleep 3

# 安装 dnsmasq + sniproxy
wget --no-check-certificate -O dnsmasq_sniproxy.sh https://raw.githubusercontent.com/myxuchangbin/dnsmasq_sniproxy_install/master/dnsmasq_sniproxy.sh
chmod +x dnsmasq_sniproxy.sh
echo "" | bash dnsmasq_sniproxy.sh -id

sleep 5

# 覆盖 dnsmasq 配置
wget https://raw.githubusercontent.com/laoxiechuzheng/xrayr-1/refs/heads/main/awsjp-dns -O /etc/dnsmasq.conf
sleep 2
rm -rf /etc/dnsmasq.d/custom_netflix.conf
systemctl restart dnsmasq
sleep 3
rm -rf /etc/resolv.conf && echo 'nameserver 127.0.0.1' > /etc/resolv.conf
sleep 3

# 安装 BBR 加速
wget https://raw.githubusercontent.com/laoxiechuzheng/xrayr-1/refs/heads/main/dlsbbr.sh && bash dlsbbr.sh


echo "========== 初始化配置完成 =========="
