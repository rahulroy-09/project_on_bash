#!/bin/bash

echo "===== WEBSITE IP ADDRESS ====="
nslookup github.com
echo "===== HTTP HEADERS ====="
curl -I https://github.com
echo "===== WEBSITE RESPONSE ====="
curl -L https://github.com
echo "===== ROBOTS FILE ====="
curl https://github.com/github.txt
echo "===== SSL CERTIFICATE INFO ====="
openssl s_client -connect github.com:443
