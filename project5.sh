  #!/bin/bash

#############################################################
# IP Address Analyzer - Complete conversion suite
# with colorful output
#############################################################

# Color definitions
HEADER='\033[95m'
BLUE='\033[94m'
CYAN='\033[96m'
GREEN='\033[92m'
YELLOW='\033[93m'
RED='\033[91m'
RESET='\033[0m'
BOLD='\033[1m'

# Print colorful header
print_header() {
    echo -e "\n${CYAN}======================================================================${RESET}"
    echo -e "${BOLD}${HEADER}              IP ADDRESS ANALYZER & CONVERTER                  ${RESET}"
    echo -e "${CYAN}======================================================================${RESET}\n"
}

# Print colorful footer
print_footer() {
    echo -e "\n${CYAN}======================================================================${RESET}"
    echo -e "${BOLD}${GREEN}                      Analysis Complete!                          ${RESET}"
    echo -e "${CYAN}======================================================================${RESET}\n"
}

# Validate IP address
validate_ip() {
    local ip=$1
    local stat=1

    if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        IFS='.' read -r -a octets <<< "$ip"
        [[ ${octets[0]} -le 255 && ${octets[1]} -le 255 && \
           ${octets[2]} -le 255 && ${octets[3]} -le 255 ]]
        stat=$?
    else
        stat=1
    fi
    return $stat
}

# Get IP class
get_ip_class() {
    local first_octet=$1
    local class=""
    local description=""

    if [ $first_octet -ge 1 ] && [ $first_octet -le 126 ]; then
        class="A"
        description="Unicast - Large Networks"
    elif [ $first_octet -eq 127 ]; then
        class="A"
        description="Loopback"
    elif [ $first_octet -ge 128 ] && [ $first_octet -le 191 ]; then
        class="B"
        description="Unicast - Medium Networks"
    elif [ $first_octet -ge 192 ] && [ $first_octet -le 223 ]; then
        class="C"
        description="Unicast - Small Networks"
    elif [ $first_octet -ge 224 ] && [ $first_octet -le 239 ]; then
        class="D"
        description="Multicast"
    elif [ $first_octet -ge 240 ] && [ $first_octet -le 255 ]; then
        class="E"
        description="Experimental/Reserved"
    else
        class="Unknown"
        description="Invalid"
    fi

    echo "$class|$description"
}

# Convert decimal to binary (8-bit)
dec_to_bin() {
    local num=$1
    local binary=""
    for i in {7..0}; do
        binary="${binary}$((num >> i & 1))"
    done
    echo "$binary"
}

# Convert IP to binary
ip_to_binary() {
    local ip=$1
    IFS='.' read -r -a octets <<< "$ip"
    local binary=""
    
    for octet in "${octets[@]}"; do
        if [ -z "$binary" ]; then
            binary=$(dec_to_bin $octet)
        else
            binary="${binary}.$(dec_to_bin $octet)"
        fi
    done
    echo "$binary"
}

# Convert binary to hex
binary_to_hex() {
    local binary_ip=$1
    IFS='.' read -r -a binary_octets <<< "$binary_ip"
    local hex=""
    
    for bin_octet in "${binary_octets[@]}"; do
        local decimal=$((2#$bin_octet))
        if [ -z "$hex" ]; then
            hex=$(printf "%02X" $decimal)
        else
            hex="${hex}.$(printf "%02X" $decimal)"
        fi
    done
    echo "$hex"
}

# Convert IP to quad (32-bit integer)
ip_to_quad() {
    local ip=$1
    IFS='.' read -r -a octets <<< "$ip"
    local quad=$((${octets[0]} * 256**3 + ${octets[1]} * 256**2 + ${octets[2]} * 256 + ${octets[3]}))
    echo "$quad"
}

# Convert quad to binary (32-bit)
quad_to_binary() {
    local quad=$1
    local binary=""
    for i in {31..0}; do
        binary="${binary}$((quad >> i & 1))"
    done
    echo "$binary"
}

# Convert IP to octal
ip_to_octal() {
    local ip=$1
    IFS='.' read -r -a octets <<< "$ip"
    local octal=""
    
    for octet in "${octets[@]}"; do
        if [ -z "$octal" ]; then
            octal=$(printf "%03o" $octet)
        else
            octal="${octal}.$(printf "%03o" $octet)"
        fi
    done
    echo "$octal"
}

# Print formatted result
print_result() {
    local label=$1
    local value=$2
    printf "${BOLD}${CYAN}%-40s${RESET} ${YELLOW}%s${RESET}\n" "$label" "$value"
}

# Main analysis function
analyze_ip() {
    local ip=$1
    
    print_header
    
    # Original IP
    echo -e "${BOLD}${BLUE}[1] ORIGINAL IP ADDRESS${RESET}"
    print_result "IP Address.............................." "$ip"
    
    # IP Class
    IFS='.' read -r -a octets <<< "$ip"
    local first_octet=${octets[0]}
    local class_info=$(get_ip_class $first_octet)
    IFS='|' read -r class description <<< "$class_info"
    
    echo -e "\n${BOLD}${BLUE}[2] IP ADDRESS CLASS${RESET}"
    print_result "Class..................................." "$class"
    print_result "Description............................." "$description"
    
    # Binary conversion
    local binary=$(ip_to_binary "$ip")
    echo -e "\n${BOLD}${BLUE}[3] BINARY REPRESENTATION${RESET}"
    print_result "Binary.................................." "$binary"
    
    # Hexadecimal conversion
    local hexadecimal=$(binary_to_hex "$binary")
    echo -e "\n${BOLD}${BLUE}[4] HEXADECIMAL REPRESENTATION${RESET}"
    print_result "Hexadecimal............................." "$hexadecimal"
    
    # Quad conversion
    local quad=$(ip_to_quad "$ip")
    echo -e "\n${BOLD}${BLUE}[5] QUAD (32-BIT INTEGER)${RESET}"
    print_result "Quad/Decimal............................" "$quad"
    
    # Quad to binary
    local quad_binary=$(quad_to_binary $quad)
    echo -e "\n${BOLD}${BLUE}[6] QUAD TO BINARY (CONTINUOUS)${RESET}"
    print_result "Binary (32-bit)........................." "$quad_binary"
    
    # Octal conversion
    local octal=$(ip_to_octal "$ip")
    echo -e "\n${BOLD}${BLUE}[7] OCTAL REPRESENTATION${RESET}"
    print_result "Octal..................................." "$octal"
    
    # Summary table
    echo -e "\n${BOLD}${BLUE}[8] CONVERSION SUMMARY${RESET}"
    echo -e "${GREEN}┌────────────────────────────────────────────────────────────────────┐${RESET}"
    printf "${GREEN}│${RESET}${BOLD} %-20s ${GREEN}│${RESET} %-44s ${GREEN}│${RESET}\n" "Format" "Value"
    echo -e "${GREEN}├────────────────────────────────────────────────────────────────────┤${RESET}"
    printf "${GREEN}│${RESET} ${YELLOW}%-20s${RESET} ${GREEN}│${RESET} %-44s ${GREEN}│${RESET}\n" "Decimal (Dotted)" "$ip"
    printf "${GREEN}│${RESET} ${YELLOW}%-20s${RESET} ${GREEN}│${RESET} %-44s ${GREEN}│${RESET}\n" "Binary (Dotted)" "$binary"
    printf "${GREEN}│${RESET} ${YELLOW}%-20s${RESET} ${GREEN}│${RESET} %-44s ${GREEN}│${RESET}\n" "Hexadecimal" "$hexadecimal"
    printf "${GREEN}│${RESET} ${YELLOW}%-20s${RESET} ${GREEN}│${RESET} %-44s ${GREEN}│${RESET}\n" "Decimal (32-bit)" "$quad"
    printf "${GREEN}│${RESET} ${YELLOW}%-20s${RESET} ${GREEN}│${RESET} %-44s ${GREEN}│${RESET}\n" "Binary (32-bit)" "$quad_binary"
    printf "${GREEN}│${RESET} ${YELLOW}%-20s${RESET} ${GREEN}│${RESET} %-44s ${GREEN}│${RESET}\n" "Octal" "$octal"
    echo -e "${GREEN}└────────────────────────────────────────────────────────────────────┘${RESET}"
    
    print_footer
}

# Get system IP address automatically
get_system_ip() {
    local ip=""
    
    # Try multiple methods to get IP address
    
    # Method 1: Using hostname command
    ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    
    # Method 2: Using ip command (more reliable)
    if [ -z "$ip" ]; then
        ip=$(ip route get 1.1.1.1 2>/dev/null | grep -oP 'src \K\S+')
    fi
    
    # Method 3: Using ifconfig
    if [ -z "$ip" ]; then
        ip=$(ifconfig 2>/dev/null | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -n1)
    fi
    
    # Method 4: Check network interfaces directly
    if [ -z "$ip" ]; then
        ip=$(ip addr show 2>/dev/null | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1 | head -n1)
    fi
    
    echo "$ip"
}

# Main execution
main() {
    local ip_address=""
    
    if [ $# -gt 0 ]; then
        ip_address=$1
    else
        # Automatically detect system IP
        echo -e "${BOLD}${CYAN}Detecting system IP address...${RESET}\n"
        ip_address=$(get_system_ip)
        
        if [ -z "$ip_address" ]; then
            echo -e "${RED}${BOLD}ERROR: Could not detect system IP address automatically!${RESET}"
            echo -e -n "${BOLD}${CYAN}Please enter IP Address manually: ${RESET}"
            read ip_address
        else
            echo -e "${GREEN}${BOLD}✓ Detected IP Address: ${YELLOW}$ip_address${RESET}\n"
            sleep 1
        fi
    fi
    
    if validate_ip "$ip_address"; then
        analyze_ip "$ip_address"
    else
        echo -e "\n${RED}${BOLD}ERROR: Invalid IP address format!${RESET}"
        echo -e "${YELLOW}Please enter a valid IP address (e.g., 192.168.1.1)${RESET}\n"
        exit 1
    fi
}

# Run main function
main "$@"









