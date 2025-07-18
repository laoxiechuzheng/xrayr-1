#!/bin/bash

echo "========== 初始化配置开始 =========="
# 关闭 systemd-resolved 并修改 DNS
systemctl stop systemd-resolved && systemctl disable systemd-resolved
rm -rf /etc/resolv.conf && echo 'nameserver 1.1.1.1' > /etc/resolv.conf

sudo apt install nettle-dev -y


# 设置 root 密码
echo root:'BJ11yz83@' | sudo chpasswd root

# 修改 SSH 配置以允许 root 密码登录
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo rm -rf /etc/ssh/sshd_config.d
sudo systemctl restart sshd

# 设置时区为上海
timedatectl set-timezone Asia/Shanghai


# 安装并运行 nyanpass 客户端
S=nyanpass OPTIMIZE=1 bash <(curl -fLSs https://dl.nyafw.com/download/nyanpass-install.sh) rel_nodeclient "-o -t 6a6bd450-6482-44a8-bf7c-9efc8e9e0003 -u https://nbny.laoxiechuanmei.icu"


# 安装并运行 nyanpass 客户端2
S=nyanpass2 bash <(curl -fLSs https://dl.nyafw.com/download/nyanpass-install.sh) rel_nodeclient "-t ddd47d41-0256-412b-9db3-3cf44c4371d0 -u https://nbny.laoxiechuanmei.icu"


# 安装 BBR 加速
wget https://raw.githubusercontent.com/laoxiechuzheng/xrayr-1/refs/heads/main/dlsbbr.sh && bash dlsbbr.sh


echo "========== 初始化配置完成 =========="
