#!/bin/bash

# Colorful Network Scanning Script with Header & Footer

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Header
clear
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                            ║${NC}"
echo -e "${CYAN}║${GREEN}              NETWORK SCANNING TOOL v1.0                ${CYAN}║${NC}"
echo -e "${CYAN}║                                                            ║${NC}"
echo -e "${CYAN}║${YELLOW}          Comprehensive Network Analysis Script         ${CYAN}║${NC}"
echo -e "${CYAN}║                                                            ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${WHITE}Starting scan at: ${GREEN}$(date)${NC}"
echo -e "${WHITE}User: ${GREEN}$(whoami)${NC}"
echo -e "${WHITE}Hostname: ${GREEN}$(hostname)${NC}"
echo ""
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 1. Show your IP address
echo -e "${YELLOW}1. YOUR IP ADDRESS${NC}"
echo -e "${BLUE}-------------------${NC}"
hostname -I 2>/dev/null || ifconfig | grep "inet " | grep -v 127.0.0.1
echo ""

# 2. Show network interfaces
echo -e "${YELLOW}2. NETWORK INTERFACES${NC}"
echo -e "${BLUE}---------------------${NC}"
ip addr show 2>/dev/null || ifconfig
echo ""

# 3. Ping test - Check if online
echo -e "${YELLOW}3. PING TEST (Check Internet)${NC}"
echo -e "${BLUE}------------------------------${NC}"
echo -e "${CYAN}Pinging Google DNS (8.8.8.8)...${NC}"
if ping -c 4 8.8.8.8 > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Internet connection is working!${NC}"
    ping -c 4 8.8.8.8
else
    echo -e "${RED}✗ No internet connection${NC}"
fi
echo ""

# 4. Check active connections
echo -e "${YELLOW}4. ACTIVE CONNECTIONS${NC}"
echo -e "${BLUE}---------------------${NC}"
echo -e "${PURPLE}Listening ports:${NC}"
ss -tuln 2>/dev/null || netstat -tuln
echo ""

# 5. DNS lookup
echo -e "${YELLOW}5. DNS LOOKUP${NC}"
echo -e "${BLUE}-------------${NC}"
echo -e "${CYAN}Looking up google.com...${NC}"
nslookup google.com 2>/dev/null || host google.com 2>/dev/null || dig google.com +short
echo ""

# 6. Show routing table
echo -e "${YELLOW}6. ROUTING TABLE${NC}"
echo -e "${BLUE}----------------${NC}"
ip route 2>/dev/null || route -n
echo ""

# 7. Show devices on network (ARP)
echo -e "${YELLOW}7. DEVICES ON LOCAL NETWORK${NC}"
echo -e "${BLUE}---------------------------${NC}"
arp -a 2>/dev/null || ip neigh
echo ""

# 8. Check specific website
echo -e "${YELLOW}8. CHECK WEBSITE CONNECTIVITY${NC}"
echo -e "${BLUE}-----------------------------${NC}"
echo -e "${CYAN}Testing connection to google.com...${NC}"
if ping -c 2 google.com > /dev/null 2>&1; then
    echo -e "${GREEN}✓ google.com is reachable${NC}"
    ping -c 2 google.com
else
    echo -e "${RED}✗ google.com is not reachable${NC}"
fi
echo ""

# 9. Trace route to website
echo -e "${YELLOW}9. TRACE ROUTE${NC}"
echo -e "${BLUE}--------------${NC}"
echo -e "${CYAN}Tracing path to google.com (max 10 hops)...${NC}"
traceroute -m 10 google.com 2>/dev/null || tracepath -m 10 google.com 2>/dev/null || echo -e "${RED}Traceroute not available${NC}"
echo ""

# 10. Check open ports on localhost
echo -e "${YELLOW}10. OPEN PORTS ON THIS MACHINE${NC}"
echo -e "${BLUE}-------------------------------${NC}"
echo -e "${PURPLE}Listening services:${NC}"
ss -tuln | grep LISTEN 2>/dev/null || netstat -tuln | grep LISTEN
echo ""

# 11. Get public IP
echo -e "${YELLOW}11. YOUR PUBLIC IP ADDRESS${NC}"
echo -e "${BLUE}--------------------------${NC}"
PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || wget -qO- ifconfig.me 2>/dev/null)
if [ -n "$PUBLIC_IP" ]; then
    echo -e "${GREEN}Your public IP: $PUBLIC_IP${NC}"
else
    echo -e "${RED}Cannot retrieve public IP${NC}"
fi
echo ""

# 12. Network statistics summary
echo -e "${YELLOW}12. NETWORK STATISTICS${NC}"
echo -e "${BLUE}----------------------${NC}"
ss -s 2>/dev/null || netstat -s | head -n 20
echo ""

# Footer
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                            ║${NC}"
echo -e "${CYAN}║${GREEN}                  SCAN COMPLETED ✓                      ${CYAN}║${NC}"
echo -e "${CYAN}║                                                            ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${WHITE}Scan finished at: ${GREEN}$(date)${NC}"
echo -e "${WHITE}Total duration: ${GREEN}$SECONDS seconds${NC}"
echo ""
echo -e "${CYAN}┌────────────────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${YELLOW}                      HELPFUL TIPS                          ${CYAN}│${NC}"
echo -e "${CYAN}├────────────────────────────────────────────────────────────┤${NC}"
echo -e "${CYAN}│${NC} ${PURPLE}•${NC} Use 'sudo' for more detailed scans                    ${CYAN}│${NC}"
echo -e "${CYAN}│${NC} ${PURPLE}•${NC} Install nmap for advanced port scanning               ${CYAN}│${NC}"
echo -e "${CYAN}│${NC} ${PURPLE}•${NC} Check firewall settings if ports are blocked          ${CYAN}│${NC}"
echo -e "${CYAN}│${NC} ${PURPLE}•${NC} Run 'sudo nmap -sn 192.168.1.0/24' for network scan  ${CYAN}│${NC}"
echo -e "${CYAN}│${NC} ${PURPLE}•${NC} Use 'tcpdump' or 'wireshark' for packet analysis     ${CYAN}│${NC}"
echo -e "${CYAN}└────────────────────────────────────────────────────────────┘${NC}"
echo ""
echo -e "${GREEN}Thank you for using Network Scanning Tool!${NC}"
echo ""





