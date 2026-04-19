#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

clear
echo -e "${CYAN}${BOLD}"
echo "  ██████╗ ██████╗ ██████╗ "
echo "  ██╔══██╗██╔══██╗██╔══██╗"
echo "  ██████╔╝██████╔╝██████╔╝"
echo "  ██╔══██╗██╔══██╗██╔══██╗"
echo "  ██████╔╝██████╔╝██╔══██╝"
echo "  ╚═════╝ ╚═════╝ ╚═╝     "
echo -e "${NC}"
echo -e "${BOLD}         BBR 参数管理工具${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${GREEN}1${NC}  第六感 BBR         ${CYAN}(通用高性能)${NC}"
echo -e "  ${GREEN}2${NC}  亚太 BBR            ${CYAN}(60ms 低延迟中转)${NC}"
echo -e "  ${GREEN}3${NC}  4837 BBR            ${CYAN}(200ms 高延迟入口)${NC}"
echo -e "  ${GREEN}4${NC}  落地 BBR            ${CYAN}(<20ms 落地机)${NC}"
echo -e "  ${GREEN}5${NC}  TC 队列调优         ${CYAN}(FQ 抢占参数)${NC}"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -ne "\n  请输入选项 ${BOLD}[1-5]${NC}："
read -r choice

case "$choice" in
  1)
    echo ""
    echo -e "  ${GREEN}▶ 正在应用第六感 BBR...${NC}"
    wget -qO- https://raw.githubusercontent.com/laoxiechuzheng/xrayr-1/refs/heads/main/sixsexbbr.sh | bash
    ;;
  2)
    echo ""
    echo -e "  ${GREEN}▶ 正在应用亚太 BBR...${NC}"
    wget -qO- https://raw.githubusercontent.com/laoxiechuzheng/xrayr-1/refs/heads/main/ytbbr.sh | bash
    ;;
  3)
    echo ""
    echo -e "  ${GREEN}▶ 正在应用 4837 BBR...${NC}"
    wget -qO- https://raw.githubusercontent.com/laoxiechuzheng/xrayr-1/refs/heads/main/4837bbr.sh | bash
    ;;
  4)
    echo ""
    echo -e "  ${GREEN}▶ 正在应用落地 BBR...${NC}"
    wget -qO- https://raw.githubusercontent.com/laoxiechuzheng/xrayr-1/refs/heads/main/ldbbr.sh | bash
    ;;
  5)
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${CYAN}TC FQ 队列调优${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    # 自动获取出口网卡
    IFACE=$(ip route get 8.8.8.8 2>/dev/null | grep -oP 'dev \K\S+' | head -1)
    if [ -z "$IFACE" ]; then
      IFACE=$(ip link show | grep -v lo | grep 'state UP' | head -1 | awk -F': ' '{print $2}')
    fi
    if [ -z "$IFACE" ]; then
      echo -e "  ${RED}✗ 无法自动检测网卡，请手动输入网卡名称：${NC}"
      read -r IFACE
    else
      echo -e "  ${GREEN}✓ 检测到出口网卡：${BOLD}${IFACE}${NC}"
    fi

    echo ""
    echo -e "  当前固定参数："
    echo -e "  ${CYAN}quantum       = 9000${NC}"
    echo -e "  ${CYAN}initial_quantum = 45000${NC}"
    echo -e "  ${CYAN}flow_limit    = 800${NC}"
    echo -e "  ${CYAN}refill_delay  = 10${NC}"
    echo ""
    echo -ne "  请输入 ${BOLD}maxrate${NC} 值（单位 mbit，例如 950 / 550 / 3000）："
    read -r MAXRATE

    # 验证输入是否为数字
    if ! [[ "$MAXRATE" =~ ^[0-9]+$ ]]; then
      echo ""
      echo -e "  ${RED}✗ 输入无效，请输入纯数字（如 950）${NC}"
      exit 1
    fi

    echo ""
    echo -e "  ${GREEN}▶ 正在应用 TC 参数到网卡 ${BOLD}${IFACE}${NC}，maxrate = ${BOLD}${MAXRATE}mbit${NC}..."
    echo ""

    tc qdisc replace dev "$IFACE" root fq \
      maxrate "${MAXRATE}mbit" \
      quantum 9000 \
      initial_quantum 45000 \
      flow_limit 800 \
      refill_delay 10

    if [ $? -eq 0 ]; then
      echo ""
      echo -e "  ${GREEN}✓ TC 参数应用成功${NC}"
      echo ""
      echo -e "  当前队列状态："
      tc qdisc show dev "$IFACE"
    else
      echo ""
      echo -e "  ${RED}✗ TC 参数应用失败，请检查是否以 root 运行${NC}"
    fi
    ;;
  *)
    echo ""
    echo -e "  ${RED}✗ 无效选项，请输入 1-5${NC}"
    exit 1
    ;;
esac

echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${GREEN}✓ 完成${NC}"
echo ""
