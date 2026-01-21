#!/bin/bash

echo "===== NETWORK INTERFACES ====="
ip link
echo "===== IP ROUTE TABLE ====="
ip route
echo "===== ARP TABLE ====="
arp -a
echo "===== DNS CONFIGURATION ====="
cat /etc/resolv.conf
echo "===== ACTIVE CONNECTIONS ====="
netstat -tulnp
