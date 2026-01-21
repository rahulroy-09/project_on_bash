#!/bin/bash
echo "===== HOSTNAME INFORMATION ====="
hostname
echo "===== IP ADDRESS INFORMATION ====="
ip addr show
echo "===== DNS LOOKUP ====="
nslookup google.com
echo "===== NETWORK PATH ====="
traceroute google.com
echo "===== PING TEST ====="
ping -c 4 google.com
echo "===== OPEN PORT CHECK (LOCAL) ====="
ss -tuln
