#!/bin/bash

# System Information Script with Colors

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${CYAN}================================${NC}"
echo -e "${CYAN}   SYSTEM INFORMATION REPORT${NC}"
echo -e "${CYAN}================================${NC}"
echo ""

echo -e "${GREEN}Date and Time:${NC}"
date
echo ""

echo -e "${GREEN}User:${NC}"
whoami
echo ""

echo -e "${GREEN}Hostname:${NC}"
hostname
echo ""

echo -e "${GREEN}Current Directory:${NC}"
pwd
echo ""

echo -e "${YELLOW}Disk Usage:${NC}"
df -h | head -n 5
echo ""

echo -e "${YELLOW}Memory Usage:${NC}"
free -h
echo ""

echo -e "${RED}Top 5 Processes:${NC}"
ps aux --sort=-%cpu | head -n 6
echo ""

echo -e "${BLUE}Uptime:${NC}"
uptime
echo ""

echo -e "${MAGENTA}Files in Directory:${NC}"
ls -l | grep "^-" | wc -l
echo ""

echo -e "${MAGENTA}Network Interfaces:${NC}"
ip addr show | grep "inet " | head -n 3
echo ""

echo -e "${CYAN}================================${NC}"
echo -e "${GREEN}Report Complete!${NC}"
echo -e "${CYAN}================================${NC}"
























