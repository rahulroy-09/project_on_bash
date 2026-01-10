#!/bin/bash

# ================== Color Definitions ==================
HEADER='\033[95m'
BLUE='\033[94m'
CYAN='\033[96m'
GREEN='\033[92m'
YELLOW='\033[93m'
RED='\033[91m'
BOLD='\033[1m'
RESET='\033[0m'

print_header() {
    echo -e "\n${HEADER}${BOLD}"
    echo "============================================================"
    echo "        🔐  CRYPTO HASH CONVERSION CHAIN TOOL"
    echo "============================================================"
    echo -e "${RESET}"
}

print_footer() {
    echo -e "\n${HEADER}${BOLD}"
    echo "============================================================"
    echo "               ✔ Process Completed Successfully"
    echo "============================================================"
    echo -e "${RESET}"
}

if [ $# -ne 1 ]; then
    echo -e "${RED}Usage: $0 \"text to hash\"${RESET}"
    exit 1
fi

TEXT="$1"

print_header

echo -e "${CYAN}[*] Input Text:${RESET} ${YELLOW}$TEXT${RESET}\n"

# Step 1: MD5
MD5_HASH=$(echo -n "$TEXT" | openssl md5 | awk '{print $2}')
echo -e "${BLUE}[1] MD5:${RESET}        ${GREEN}$MD5_HASH${RESET}"

# Prepare public key
if [ ! -f public.pem ]; then
    openssl pkey -in private.pem -pubout -out public.pem 2>/dev/null
fi

# Step 2: RSA encrypt MD5 using pkeyutl
RSA_OUT=$(echo -n "$MD5_HASH" | openssl pkeyutl -encrypt -pubin -inkey public.pem | base64)
echo -e "${BLUE}[2] RSA:${RESET}        ${GREEN}$RSA_OUT${RESET}"

# Step 3: SHA1
SHA1_HASH=$(echo -n "$RSA_OUT" | openssl dgst -sha1 | awk '{print $2}')
echo -e "${BLUE}[3] SHA1:${RESET}       ${GREEN}$SHA1_HASH${RESET}"

# Step 4: SHA256
SHA256_HASH=$(echo -n "$SHA1_HASH" | openssl dgst -sha256 | awk '{print $2}')
echo -e "${BLUE}[4] SHA256:${RESET}     ${GREEN}$SHA256_HASH${RESET}"

print_footer
















