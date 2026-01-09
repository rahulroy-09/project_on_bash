#!/bin/bash

# Service Status Checker for Kali Linux
# This script checks all installed services and their current status

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if running as root (optional, but some info requires it)
if [ "$EUID" -ne 0 ]; then 
    echo -e "${YELLOW}Warning: Not running as root. Some information may be limited.${NC}"
    echo ""
fi

echo "=========================================="
echo "  Service Status Checker - Kali Linux"
echo "=========================================="
echo ""

# Function to display service status with color
display_status() {
    local service=$1
    local status=$2
    
    if echo "$status" | grep -q "active (running)"; then
        echo -e "${GREEN}[RUNNING]${NC} $service"
    elif echo "$status" | grep -q "inactive"; then
        echo -e "${RED}[STOPPED]${NC} $service"
    elif echo "$status" | grep -q "failed"; then
        echo -e "${RED}[FAILED]${NC} $service"
    else
        echo -e "${YELLOW}[OTHER]${NC} $service - $status"
    fi
}

# Option 1: List all systemd services
echo -e "${BLUE}=== All Systemd Services ===${NC}"
echo ""

# Get list of all service units
systemctl list-units --type=service --all --no-pager | tail -n +2 | head -n -6 | while read line; do
    service_name=$(echo "$line" | awk '{print $1}')
    load_state=$(echo "$line" | awk '{print $2}')
    active_state=$(echo "$line" | awk '{print $3}')
    sub_state=$(echo "$line" | awk '{print $4}')
    
    status="$active_state ($sub_state)"
    display_status "$service_name" "$status"
done

echo ""
echo "=========================================="
echo ""

# Summary statistics
echo -e "${BLUE}=== Service Summary ===${NC}"
echo ""

total_services=$(systemctl list-units --type=service --all --no-pager | grep "loaded" | wc -l)
running_services=$(systemctl list-units --type=service --state=running --no-pager | tail -n +2 | head -n -6 | wc -l)
failed_services=$(systemctl list-units --type=service --state=failed --no-pager | tail -n +2 | head -n -6 | wc -l)

echo -e "Total Services: ${BLUE}$total_services${NC}"
echo -e "Running Services: ${GREEN}$running_services${NC}"
echo -e "Failed Services: ${RED}$failed_services${NC}"

echo ""

# Show failed services if any
if [ "$failed_services" -gt 0 ]; then
    echo -e "${RED}=== Failed Services ===${NC}"
    systemctl list-units --type=service --state=failed --no-pager
    echo ""
fi

# Optional: Show enabled services that will start at boot
echo -e "${BLUE}=== Services Enabled at Boot ===${NC}"
echo ""
systemctl list-unit-files --type=service --state=enabled --no-pager | tail -n +2 | head -n -2 | awk '{print $1}' | while read service; do
    echo -e "${GREEN}✓${NC} $service"
done

echo ""
echo "=========================================="
echo "Script completed!"
echo ""
echo "Useful commands:"
echo "  - Check specific service: systemctl status <service-name>"
echo "  - Start a service: sudo systemctl start <service-name>"
echo "  - Stop a service: sudo systemctl stop <service-name>"
echo "  - Enable at boot: sudo systemctl enable <service-name>"
echo "  - Disable at boot: sudo systemctl disable <service-name>"
