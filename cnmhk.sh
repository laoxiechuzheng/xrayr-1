#!/bin/bash

echo "========== 初始化配置开始 =========="


# 安装并运行 nyanpass 客户端
S=egsdgc OPTIMIZE=1 bash <(curl -fLSs https://dl.nyafw.com/download/nyanpass-install.sh) rel_nodeclient "-o -t 6a6bd450-6482-44a8-bf7c-9efc8e9e0003 -u https://nbny.laoxiechuanmei.icu"


# 安装并运行 nyanpass 客户端2
S=gawsg2 bash <(curl -fLSs https://dl.nyafw.com/download/nyanpass-install.sh) rel_nodeclient "-t ddd47d41-0256-412b-9db3-3cf44c4371d0 -u https://nbny.laoxiechuanmei.icu"


# 安装 BBR 加速
wget https://raw.githubusercontent.com/laoxiechuzheng/xrayr-1/refs/heads/main/dlsbbr.sh && bash dlsbbr.sh


echo "========== 初始化配置完成 =========="
