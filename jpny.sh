#!/bin/bash

echo "========== 初始化配置开始 =========="

sudo sed -i '/backports/ s/^/#/' /etc/apt/sources.list
sudo apt update

# 安装并运行 nyanpass 客户端
S=nyanpass OPTIMIZE=1 INSTALL_TOOLS=1 bash <(curl -fLSs https://dl.nyafw.com/download/nyanpass-install.sh) rel_nodeclient "-t 6a6bd450-6482-44a8-bf7c-9efc8e9e0003 -u https://nbny.laoxiechuanmei.icu"



echo "========== 初始化配置完成 =========="
