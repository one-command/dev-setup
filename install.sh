#!/bin/bash

# One Command Dev Setup - Quick Installer
# Made by Daniel D - https://www.youtube.com/@one-command
# This wrapper ensures interactive prompts work correctly

set -e

SCRIPT_URL="https://raw.githubusercontent.com/one-command/dev-setup/main/devsetup.sh"
TEMP_SCRIPT="/tmp/onecommand-devsetup-$$.sh"

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                        ║${NC}"
echo -e "${CYAN}║     🚀 One Command Dev Setup 🚀        ║${NC}"
echo -e "${CYAN}║                                        ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}✗ Please do not run this script as root or with sudo${NC}"
    echo -e "${YELLOW}  The script will ask for sudo password when needed${NC}"
    exit 1
fi

# Check for curl
if ! command -v curl &> /dev/null; then
    echo -e "${RED}✗ curl is not installed${NC}"
    echo -e "${YELLOW}  Install it with: sudo apt-get install curl${NC}"
    exit 1
fi

echo -e "${YELLOW}📥 Downloading installation script...${NC}"

# Download the script
if curl -fsSL "$SCRIPT_URL" -o "$TEMP_SCRIPT"; then
    echo -e "${GREEN}✓ Script downloaded successfully!${NC}"
    echo ""
else
    echo -e "${RED}✗ Failed to download script${NC}"
    echo -e "${YELLOW}  Please check your internet connection and try again${NC}"
    rm -f "$TEMP_SCRIPT"
    exit 1
fi

# Make executable
chmod +x "$TEMP_SCRIPT"

# Execute with a new bash process that has proper stdin
if [ -t 0 ]; then
    # stdin is a terminal, run directly
    bash "$TEMP_SCRIPT"
else
    # stdin is piped, need to reconnect to terminal
    bash "$TEMP_SCRIPT" < /dev/tty
fi

# Capture exit code
EXIT_CODE=$?

# Cleanup
rm -f "$TEMP_SCRIPT"

exit $EXIT_CODE