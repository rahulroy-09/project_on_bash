#!/bin/bash

# ================= Colors =================
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
    echo "=============================================================="
    echo "        🔐  CRYPTO MULTI-CHAIN ENCRYPTION & ENCODING TOOL"
    echo "=============================================================="
    echo -e "${RESET}"
}

print_footer() {
    echo -e "\n${HEADER}${BOLD}"
    echo "=============================================================="
    echo "               ✔ Operation Completed Successfully"
    echo "=============================================================="
    echo -e "${RESET}"
}

if [ $# -ne 1 ]; then
    echo -e "${RED}Usage: $0 \"text\"${RESET}"
    exit 1
fi

TEXT="$1"

print_header
echo -e "${CYAN}[*] Input Text:${RESET} ${YELLOW}$TEXT${RESET}\n"

# Prepare public key for RSA
if [ ! -f public.pem ]; then
    openssl pkey -in private.pem -pubout -out public.pem 2>/dev/null
fi

# ========== RSA Chain ==========
echo -e "${BOLD}${BLUE}--- RSA → Base64 → Base32 → Base16 ---${RESET}"

RSA_BIN=$(echo -n "$TEXT" | openssl pkeyutl -encrypt -pubin -inkey public.pem)
RSA_B64=$(echo "$RSA_BIN" | base64)
RSA_B32=$(echo "$RSA_B64" | base32)
RSA_B16=$(echo "$RSA_B32" | xxd -p | tr -d '\n')

echo -e "${GREEN}[RSA Base64]:${RESET} $RSA_B64"
echo -e "${GREEN}[RSA Base32]:${RESET} $RSA_B32"
echo -e "${GREEN}[RSA Base16]:${RESET} $RSA_B16\n"

# ========== SHA1 Chain ==========
echo -e "${BOLD}${BLUE}--- SHA1 → Base64 → Base32 → Base16 ---${RESET}"

SHA1=$(echo -n "$TEXT" | openssl dgst -sha1 | awk '{print $2}')
SHA1_B64=$(echo -n "$SHA1" | base64)
SHA1_B32=$(echo -n "$SHA1_B64" | base32)
SHA1_B16=$(echo -n "$SHA1_B32" | xxd -p | tr -d '\n')

echo -e "${GREEN}[SHA1 Base64]:${RESET} $SHA1_B64"
echo -e "${GREEN}[SHA1 Base32]:${RESET} $SHA1_B32"
echo -e "${GREEN}[SHA1 Base16]:${RESET} $SHA1_B16\n"

# ========== SHA256 Chain ==========
echo -e "${BOLD}${BLUE}--- SHA256 → Base64 → Base32 → Base16 ---${RESET}"

SHA256=$(echo -n "$TEXT" | openssl dgst -sha256 | awk '{print $2}')
SHA256_B64=$(echo -n "$SHA256" | base64)
SHA256_B32=$(echo -n "$SHA256_B64" | base32)
SHA256_B16=$(echo -n "$SHA256_B32" | xxd -p | tr -d '\n')

echo -e "${GREEN}[SHA256 Base64]:${RESET} $SHA256_B64"
echo -e "${GREEN}[SHA256 Base32]:${RESET} $SHA256_B32"
echo -e "${GREEN}[SHA256 Base16]:${RESET} $SHA256_B16"

print_footer






