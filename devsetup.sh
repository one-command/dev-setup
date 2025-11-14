#!/bin/bash

# Dev Environment Setup Script
# Made by Daniel D - https://www.youtube.com/@one-command
# Usage: curl -s https://onecommand.dev/devsetup.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Arrays to track installations and upgrades
declare -a UPGRADEABLE_TOOLS=()
declare -a UPGRADE_COMMANDS=()
declare -a INSTALLED_TOOLS=()
declare -a SKIPPED_TOOLS=()

# User choices
INSTALL_PACKAGE_MANAGERS=false
INSTALL_DEV_TOOLS=false
INSTALL_CODE_QUALITY=false
INSTALL_PRODUCTIVITY=false

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case "$ID" in
                ubuntu)
                    OS="ubuntu"
                    OS_DISPLAY="Ubuntu"
                    ;;
                debian)
                    OS="debian"
                    OS_DISPLAY="Debian"
                    ;;
                centos|rhel|fedora)
                    OS="redhat"
                    OS_DISPLAY="$NAME"
                    ;;
                *)
                    OS="linux"
                    OS_DISPLAY="Linux"
                    ;;
            esac
        elif [ -f /etc/debian_version ]; then
            OS="debian"
            OS_DISPLAY="Debian"
        elif [ -f /etc/redhat-release ]; then
            OS="redhat"
            OS_DISPLAY="RedHat/CentOS"
        else
            OS="linux"
            OS_DISPLAY="Linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        OS_DISPLAY="macOS"
    else
        echo -e "${RED}❌ Unsupported OS${NC}"
        exit 1
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Clean up broken repositories
cleanup_broken_repos() {
    # Check for broken repos silently
    local broken_repos=$(apt-get update 2>&1 | grep -oP "ppa\.launchpadcontent\.net/[^/]+/[^/]+" | sort -u)
    
    if [ ! -z "$broken_repos" ]; then
        echo -e "${YELLOW}⚠️  Cleaning up broken repositories...${NC}"
        echo "$broken_repos" | while read repo; do
            local ppa_name=$(echo "$repo" | cut -d'/' -f2-)
            sudo add-apt-repository --remove "ppa:$ppa_name" -y > /dev/null 2>&1 || true
        done
    fi
}

# Check if snap is available
ensure_snap() {
    if ! command_exists snap; then
        echo -e "   ${YELLOW}Installing snapd...${NC}"
        sudo apt-get update -qq
        sudo apt-get install -y -qq snapd > /dev/null 2>&1
        sudo systemctl start snapd
        sudo systemctl enable snapd > /dev/null 2>&1
    fi
}

# Compare versions (returns 0 if v1 >= v2)
version_ge() {
    [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" = "$2" ]
}

# Ask user preferences
ask_preferences() {
    echo ""
    echo "=========================================="
    echo "  🎯 Installation Preferences"
    echo "=========================================="
    echo ""
    echo "This script will install essential development tools."
    echo "You can choose which additional categories to install."
    echo ""
    
    read -p "📦 Install Package Managers & Tools (Starship)? (y/n): " -n 1 -r
    echo ""
    [[ $REPLY =~ ^[Yy]$ ]] && INSTALL_PACKAGE_MANAGERS=true
    
    read -p "🛠️  Install Essential Dev Tools (Postman, DBeaver)? (y/n): " -n 1 -r
    echo ""
    [[ $REPLY =~ ^[Yy]$ ]] && INSTALL_DEV_TOOLS=true
    
    read -p "✨ Install Code Quality Tools (ESLint, Prettier, Pre-commit)? (y/n): " -n 1 -r
    echo ""
    [[ $REPLY =~ ^[Yy]$ ]] && INSTALL_CODE_QUALITY=true
    
    read -p "⚡ Install Productivity Tools (bat, exa, fzf, tldr)? (y/n): " -n 1 -r
    echo ""
    [[ $REPLY =~ ^[Yy]$ ]] && INSTALL_PRODUCTIVITY=true
    
    echo ""
    echo -e "${GREEN}✅ Preferences saved! Starting installation...${NC}"
    sleep 1
}

# Install Docker
install_docker() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}🐳 Docker Engine & Docker Compose${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if command_exists docker; then
        CURRENT_VERSION=$(docker --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1)
        echo -e "   Docker Engine ${GREEN}$CURRENT_VERSION${NC} already installed ✓"
        SKIPPED_TOOLS+=("Docker Engine $CURRENT_VERSION")
    else
        echo -e "   Installing Docker Engine..."
        
        if [ "$OS" = "ubuntu" ] || [ "$OS" = "debian" ]; then
            sudo apt-get update -qq
            sudo apt-get install -y -qq ca-certificates curl gnupg lsb-release > /dev/null 2>&1
            
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg 2>/dev/null
            
            echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
              $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            sudo apt-get update -qq
            sudo apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null 2>&1
            
            sudo usermod -aG docker $USER
            
            INSTALLED_VERSION=$(docker --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1)
            echo -e "   Docker Engine ${GREEN}$INSTALLED_VERSION${NC} installed ✓"
            INSTALLED_TOOLS+=("Docker Engine $INSTALLED_VERSION")
        fi
    fi
    
    if docker compose version >/dev/null 2>&1; then
        COMPOSE_VERSION=$(docker compose version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1)
        echo -e "   Docker Compose ${GREEN}$COMPOSE_VERSION${NC} already installed ✓"
    fi
}

# Install Git
install_git() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}🔧 Git${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if command_exists git; then
        CURRENT_VERSION=$(git --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1)
        LATEST_VERSION=$(curl -s https://api.github.com/repos/git/git/tags 2>/dev/null | grep -oP '"name": "v\K[0-9]+\.[0-9]+\.[0-9]+' | head -1 || echo "$CURRENT_VERSION")
        
        if version_ge "$CURRENT_VERSION" "$LATEST_VERSION"; then
            echo -e "   Git ${GREEN}$CURRENT_VERSION${NC} already installed ✓"
            SKIPPED_TOOLS+=("Git $CURRENT_VERSION")
        else
            echo -e "   Git ${YELLOW}$CURRENT_VERSION${NC} installed (latest: ${GREEN}$LATEST_VERSION${NC})"
            UPGRADEABLE_TOOLS+=("Git $CURRENT_VERSION → $LATEST_VERSION")
            UPGRADE_COMMANDS+=("upgrade_git")
        fi
    else
        echo -e "   Installing Git..."
        sudo apt-get update -qq
        sudo apt-get install -y -qq git > /dev/null 2>&1
        
        INSTALLED_VERSION=$(git --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1)
        echo -e "   Git ${GREEN}$INSTALLED_VERSION${NC} installed ✓"
        INSTALLED_TOOLS+=("Git $INSTALLED_VERSION")
    fi
}

# Upgrade Git function
upgrade_git() {
    echo -e "   ${CYAN}Upgrading Git...${NC}"
    
    if [ "$OS" = "ubuntu" ]; then
        # Ubuntu: Use PPA
        echo -e "   ${GRAY}Adding Git PPA for Ubuntu...${NC}"
        sudo add-apt-repository ppa:git-core/ppa -y > /dev/null 2>&1
        sudo apt-get update -qq 2>&1 | grep -v "does not have a Release file" | grep -v "Key is stored in legacy" > /dev/null || true
        
        echo -e "   ${GRAY}Installing Git update...${NC}"
        sudo apt-get install -y git 2>&1 | grep -E "Setting up git|already the newest" > /dev/null || true
        
    elif [ "$OS" = "debian" ]; then
        # Debian: Build from source or use backports
        echo -e "   ${GRAY}Checking Debian backports...${NC}"
        
        # Try backports first
        if ! grep -q "bookworm-backports" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
            echo "deb http://deb.debian.org/debian bookworm-backports main" | sudo tee /etc/apt/sources.list.d/backports.list > /dev/null
            sudo apt-get update -qq 2>&1 > /dev/null || true
        fi
        
        echo -e "   ${GRAY}Trying to install from backports...${NC}"
        sudo apt-get install -y -t bookworm-backports git 2>&1 > /dev/null || {
            echo -e "   ${YELLOW}⚠️  Backports unavailable, installing latest available version...${NC}"
            sudo apt-get install -y --only-upgrade git 2>&1 > /dev/null || true
        }
    else
        # Other distros
        echo -e "   ${GRAY}Upgrading Git...${NC}"
        sudo apt-get install -y --only-upgrade git 2>&1 > /dev/null || true
    fi
    
    # Verify upgrade
    NEW_VERSION=$(git --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1)
    echo -e "   ${GREEN}✓ Git is now at version $NEW_VERSION${NC}"
    
    # Check if it's the latest
    LATEST_VERSION=$(curl -s https://api.github.com/repos/git/git/tags 2>/dev/null | grep -oP '"name": "v\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    if [ "$NEW_VERSION" != "$LATEST_VERSION" ]; then
        echo -e "   ${YELLOW}   Note: Latest version is $LATEST_VERSION${NC}"
        echo -e "   ${GRAY}   For latest Git, you may need to build from source${NC}"
    fi
}

# Install Node.js
install_nodejs() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📗 Node.js (via nvm)${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Try to load nvm if it exists
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    if command_exists node; then
        CURRENT_VERSION=$(node --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+')
        echo -e "   Node.js ${GREEN}$CURRENT_VERSION${NC} already installed ✓"
        SKIPPED_TOOLS+=("Node.js $CURRENT_VERSION")
    else
        if [ ! -d "$HOME/.nvm" ]; then
            echo -e "   Installing nvm..."
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh 2>/dev/null | bash > /dev/null 2>&1
            
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        fi
        
        echo -e "   Installing Node.js LTS..."
        nvm install --lts > /dev/null 2>&1
        nvm use --lts > /dev/null 2>&1
        
        INSTALLED_VERSION=$(node --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+')
        echo -e "   Node.js ${GREEN}$INSTALLED_VERSION${NC} installed ✓"
        INSTALLED_TOOLS+=("Node.js $INSTALLED_VERSION")
    fi
}

# Install Python
install_python() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}🐍 Python 3${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if command_exists python3; then
        CURRENT_VERSION=$(python3 --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+')
        echo -e "   Python ${GREEN}$CURRENT_VERSION${NC} already installed ✓"
        SKIPPED_TOOLS+=("Python $CURRENT_VERSION")
    else
        echo -e "   Installing Python 3..."
        sudo apt-get install -y -qq python3 python3-pip python3-venv > /dev/null 2>&1
        
        INSTALLED_VERSION=$(python3 --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+')
        echo -e "   Python ${GREEN}$INSTALLED_VERSION${NC} installed ✓"
        INSTALLED_TOOLS+=("Python $INSTALLED_VERSION")
    fi
}

# Install Go
install_go() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}🔷 Go${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Check in PATH and common locations
    if command_exists go || [ -x "/usr/local/go/bin/go" ]; then
        if ! command_exists go && [ -x "/usr/local/go/bin/go" ]; then
            export PATH=$PATH:/usr/local/go/bin
        fi
        CURRENT_VERSION=$(go version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1)
        echo -e "   Go ${GREEN}$CURRENT_VERSION${NC} already installed ✓"
        SKIPPED_TOOLS+=("Go $CURRENT_VERSION")
    else
        # Try snap first
        ensure_snap
        if command_exists snap; then
            echo -e "   Installing Go via snap..."
            sudo snap install go --classic > /dev/null 2>&1
            
            # Verify installation
            if /snap/bin/go version > /dev/null 2>&1; then
                INSTALLED_VERSION=$(/snap/bin/go version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1)
                echo -e "   Go ${GREEN}$INSTALLED_VERSION${NC} installed ✓"
                INSTALLED_TOOLS+=("Go $INSTALLED_VERSION")
            fi
        else
            # Fallback to manual installation
            echo -e "   Installing Go manually..."
            LATEST_GO=$(curl -s https://go.dev/VERSION?m=text 2>/dev/null | head -1)
            wget -q https://go.dev/dl/${LATEST_GO}.linux-amd64.tar.gz
            sudo rm -rf /usr/local/go
            sudo tar -C /usr/local -xzf ${LATEST_GO}.linux-amd64.tar.gz
            rm ${LATEST_GO}.linux-amd64.tar.gz
            
            # Add to PATH permanently
            if ! grep -q "/usr/local/go/bin" ~/.bashrc 2>/dev/null; then
                echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
            fi
            if ! grep -q "/usr/local/go/bin" ~/.profile 2>/dev/null; then
                echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
            fi
            
            export PATH=$PATH:/usr/local/go/bin
            
            INSTALLED_VERSION=$(go version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' | head -1)
            echo -e "   Go ${GREEN}$INSTALLED_VERSION${NC} installed ✓"
            INSTALLED_TOOLS+=("Go $INSTALLED_VERSION")
        fi
    fi
}

# Install Rust
install_rust() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}🦀 Rust${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Try to load cargo env if it exists
    [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
    
    if command_exists rustc; then
        CURRENT_VERSION=$(rustc --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+')
        echo -e "   Rust ${GREEN}$CURRENT_VERSION${NC} already installed ✓"
        SKIPPED_TOOLS+=("Rust $CURRENT_VERSION")
    else
        echo -e "   Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs 2>/dev/null | sh -s -- -y > /dev/null 2>&1
        
        # Source cargo env
        [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
        
        # Add to bashrc if not already there
        if ! grep -q "cargo/env" ~/.bashrc 2>/dev/null; then
            echo '. "$HOME/.cargo/env"' >> ~/.bashrc
        fi
        
        INSTALLED_VERSION=$(rustc --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+')
        echo -e "   Rust ${GREEN}$INSTALLED_VERSION${NC} installed ✓"
        INSTALLED_TOOLS+=("Rust $INSTALLED_VERSION")
    fi
}

# Install VSCode
install_vscode() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}💻 Visual Studio Code${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if command_exists code; then
        CURRENT_VERSION=$(code --version 2>/dev/null | head -1)
        echo -e "   VSCode ${GREEN}$CURRENT_VERSION${NC} already installed ✓"
        SKIPPED_TOOLS+=("VSCode $CURRENT_VERSION")
    else
        # Try snap first
        ensure_snap
        if command_exists snap; then
            echo -e "   Installing VSCode via snap..."
            sudo snap install code --classic > /dev/null 2>&1
            
            if command_exists code; then
                INSTALLED_VERSION=$(code --version 2>/dev/null | head -1)
                echo -e "   VSCode ${GREEN}$INSTALLED_VERSION${NC} installed ✓"
                INSTALLED_TOOLS+=("VSCode $INSTALLED_VERSION")
            fi
        else
            # Fallback to apt
            echo -e "   Installing VSCode via apt..."
            wget -qO- https://packages.microsoft.com/keys/microsoft.asc 2>/dev/null | gpg --dearmor > packages.microsoft.gpg
            sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
            sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
            rm packages.microsoft.gpg
            
            sudo apt-get update -qq
            sudo apt-get install -y -qq code > /dev/null 2>&1
            
            INSTALLED_VERSION=$(code --version 2>/dev/null | head -1)
            echo -e "   VSCode ${GREEN}$INSTALLED_VERSION${NC} installed ✓"
            INSTALLED_TOOLS+=("VSCode $INSTALLED_VERSION")
        fi
    fi
}

# Install Package Managers & Tools
install_package_managers() {
    if [ "$INSTALL_PACKAGE_MANAGERS" = false ]; then
        return
    fi
    
    echo ""
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}📦 Package Managers & Tools${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Starship
    echo ""
    if command_exists starship; then
        echo -e "   ✨ Starship already installed ✓"
        SKIPPED_TOOLS+=("Starship")
    else
        echo -e "   Installing Starship..."
        curl -sS https://starship.rs/install.sh 2>/dev/null | sh -s -- -y > /dev/null 2>&1
        
        # Add to bashrc if not already there
        if ! grep -q "starship init bash" ~/.bashrc 2>/dev/null; then
            echo 'eval "$(starship init bash)"' >> ~/.bashrc
        fi
        
        echo -e "   ✨ Starship installed ✓"
        INSTALLED_TOOLS+=("Starship")
    fi
}

# Install Essential Dev Tools
install_dev_tools() {
    if [ "$INSTALL_DEV_TOOLS" = false ]; then
        return
    fi
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}🛠️  Essential Dev Tools${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    ensure_snap
    
    # Postman
    echo ""
    if snap list 2>/dev/null | grep -q postman || command_exists postman; then
        echo -e "   📮 Postman already installed ✓"
        SKIPPED_TOOLS+=("Postman")
    else
        echo -e "   Installing Postman..."
        if sudo snap install postman 2>&1 | grep -q "installed"; then
            echo -e "   📮 Postman installed ✓"
            INSTALLED_TOOLS+=("Postman")
        else
            echo -e "   ${YELLOW}⚠️  Postman installation failed${NC}"
        fi
    fi
    
    # DBeaver
    echo ""
    if snap list 2>/dev/null | grep -q dbeaver-ce || command_exists dbeaver; then
        echo -e "   🗄️  DBeaver already installed ✓"
        SKIPPED_TOOLS+=("DBeaver")
    else
        echo -e "   Installing DBeaver..."
        if sudo snap install dbeaver-ce 2>&1 | grep -q "installed"; then
            echo -e "   🗄️  DBeaver installed ✓"
            INSTALLED_TOOLS+=("DBeaver")
        else
            echo -e "   ${YELLOW}⚠️  DBeaver installation failed${NC}"
        fi
    fi
}

# Install Code Quality Tools
install_code_quality() {
    if [ "$INSTALL_CODE_QUALITY" = false ]; then
        return
    fi
    
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✨ Code Quality Tools${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    echo ""
    if command_exists pre-commit; then
        echo -e "   🪝 Pre-commit already installed ✓"
        SKIPPED_TOOLS+=("Pre-commit")
    else
        echo -e "   Installing Pre-commit..."
        # Ensure pip is installed
        if ! command_exists pip3; then
            sudo apt-get install -y -qq python3-pip > /dev/null 2>&1
        fi
        
        # Install pre-commit with timeout protection
        timeout 30 pip3 install --user pre-commit > /dev/null 2>&1 || {
            echo -e "   ${YELLOW}⚠️  Pre-commit installation timed out, trying alternative method...${NC}"
            sudo apt-get install -y -qq pre-commit > /dev/null 2>&1 || true
        }
        
        if command_exists pre-commit || [ -f "$HOME/.local/bin/pre-commit" ]; then
            # Add .local/bin to PATH if not already there
            if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
                export PATH="$HOME/.local/bin:$PATH"
                if ! grep -q "HOME/.local/bin" ~/.bashrc 2>/dev/null; then
                    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
                fi
            fi
            echo -e "   🪝 Pre-commit installed ✓"
            INSTALLED_TOOLS+=("Pre-commit")
        else
            echo -e "   ${YELLOW}⚠️  Pre-commit installation failed${NC}"
        fi
    fi
    
    echo -e "   ${GRAY}ℹ️  ESLint & Prettier: Install per-project with npm${NC}"
}

# Install Productivity Tools
install_productivity() {
    if [ "$INSTALL_PRODUCTIVITY" = false ]; then
        return
    fi
    
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}⚡ Productivity Tools${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # bat
    echo ""
    if command_exists bat || command_exists batcat; then
        echo -e "   🦇 bat already installed ✓"
        SKIPPED_TOOLS+=("bat")
    else
        echo -e "   Installing bat..."
        if sudo apt-get install -y -qq bat 2>&1 > /dev/null; then
            # Create symlink if batcat is installed instead of bat
            if command_exists batcat && ! command_exists bat; then
                sudo ln -sf /usr/bin/batcat /usr/local/bin/bat 2>/dev/null || true
            fi
            echo -e "   🦇 bat installed ✓"
            INSTALLED_TOOLS+=("bat")
        else
            echo -e "   ${YELLOW}⚠️  bat installation failed${NC}"
        fi
    fi
    
    # exa (or eza on newer systems)
    echo ""
    if command_exists exa || command_exists eza; then
        echo -e "   📂 exa already installed ✓"
        SKIPPED_TOOLS+=("exa")
    else
        echo -e "   Installing exa..."
        # Try exa first, fallback to eza
        if sudo apt-get install -y -qq exa 2>&1 > /dev/null; then
            echo -e "   📂 exa installed ✓"
            INSTALLED_TOOLS+=("exa")
        elif sudo apt-get install -y -qq eza 2>&1 > /dev/null; then
            echo -e "   📂 eza installed ✓"
            INSTALLED_TOOLS+=("eza")
        else
            echo -e "   ${YELLOW}⚠️  exa installation failed${NC}"
        fi
    fi
    
    # fzf
    echo ""
    if command_exists fzf; then
        echo -e "   🔍 fzf already installed ✓"
        SKIPPED_TOOLS+=("fzf")
    else
        echo -e "   Installing fzf..."
        if sudo apt-get install -y -qq fzf 2>&1 > /dev/null; then
            echo -e "   🔍 fzf installed ✓"
            INSTALLED_TOOLS+=("fzf")
        else
            echo -e "   ${YELLOW}⚠️  fzf installation failed${NC}"
        fi
    fi
    
    # tldr
    echo ""
    if command_exists tldr; then
        echo -e "   📖 tldr already installed ✓"
        SKIPPED_TOOLS+=("tldr")
    else
        echo -e "   Installing tldr..."
        if sudo apt-get install -y -qq tldr 2>&1 > /dev/null; then
            echo -e "   📖 tldr installed ✓"
            INSTALLED_TOOLS+=("tldr")
        else
            # Try pip as fallback
            if command_exists pip3; then
                timeout 20 pip3 install --user tldr > /dev/null 2>&1 && {
                    echo -e "   📖 tldr installed ✓"
                    INSTALLED_TOOLS+=("tldr")
                } || echo -e "   ${YELLOW}⚠️  tldr installation failed${NC}"
            else
                echo -e "   ${YELLOW}⚠️  tldr installation failed${NC}"
            fi
        fi
    fi
}

# Prompt for upgrades
prompt_upgrades() {
    if [ ${#UPGRADEABLE_TOOLS[@]} -eq 0 ]; then
        return
    fi
    
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}📦 Available Updates${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    for tool in "${UPGRADEABLE_TOOLS[@]}"; do
        echo -e "   🔄 $tool"
    done
    
    echo ""
    read -p "Would you like to upgrade these tools now? (y/n): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        
        for cmd in "${UPGRADE_COMMANDS[@]}"; do
            # Execute the upgrade function
            $cmd
        done
        
        echo -e "${GREEN}✅ Upgrades complete!${NC}"
    else
        echo -e "${YELLOW}⏭️  Skipping upgrades${NC}"
    fi
}

# Final summary
show_summary() {
    echo ""
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                        ║${NC}"
    echo -e "${GREEN}║       ✅ Setup Complete! 🎉            ║${NC}"
    echo -e "${GREEN}║                                        ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ ${#INSTALLED_TOOLS[@]} -gt 0 ]; then
        echo -e "${GREEN}📥 Newly Installed:${NC}"
        for tool in "${INSTALLED_TOOLS[@]}"; do
            echo -e "   ✓ $tool"
        done
        echo ""
    fi
    
    if [ ${#SKIPPED_TOOLS[@]} -gt 0 ]; then
        echo -e "${BLUE}✓ Already Installed:${NC}"
        for tool in "${SKIPPED_TOOLS[@]}"; do
            echo -e "   • $tool"
        done
        echo ""
    fi
    
    echo -e "${CYAN}📝 Important Notes:${NC}"
    echo -e "   • ${YELLOW}Restart your terminal${NC} to apply PATH changes"
    echo -e "   • Run: ${CYAN}source ~/.bashrc${NC} to reload your shell"
    if [ ${#INSTALLED_TOOLS[@]} -gt 0 ]; then
        echo -e "   • If Docker was installed, ${YELLOW}log out and back in${NC} for group changes"
    fi
    echo ""
    echo -e "${GRAY}Made by Daniel D - https://www.youtube.com/@one-command${NC}"
    echo ""
    echo -e "${MAGENTA}🚀 Happy coding!${NC}"
    echo ""
}

# Main execution
main() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                        ║${NC}"
    echo -e "${CYAN}║     🚀 Dev Environment Setup 🚀        ║${NC}"
    echo -e "${CYAN}║                                        ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    detect_os
    echo -e "Detected OS: ${GREEN}$OS_DISPLAY${NC}"
    
    # Clean up any broken repos before starting
    cleanup_broken_repos
    
    # Ask user preferences
    ask_preferences
    
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}Installing Core Tools...${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Core installations
    install_docker
    install_git
    install_nodejs
    install_python
    install_go
    install_rust
    install_vscode
    
    # Optional installations based on user choice
    install_package_managers
    install_dev_tools
    install_code_quality
    install_productivity
    
    # Check for upgrades
    prompt_upgrades
    
    # Show final summary
    show_summary
}

main