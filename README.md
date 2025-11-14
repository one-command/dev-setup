# 🚀 One Command Dev Setup

[![Watch the Tutorial](https://img.shields.io/badge/▶️_Watch-Tutorial-red?style=for-the-badge&logo=youtube)](https://www.youtube.com/@one-command)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Debian](https://img.shields.io/badge/Debian-D70A53?style=for-the-badge&logo=debian&logoColor=white)](https://www.debian.org/)

> **Set up your entire development environment with a single command.** No manual installations, no configuration headaches, no hours wasted. Just one line and you're ready to code.
```bash
curl -fsSL https://raw.githubusercontent.com/one-command/dev-setup/main/install.sh | bash
```

---

## ✨ What Gets Installed

### 🎯 **Core Tools** (Always Installed)
- **🐳 Docker Engine & Docker Compose** - Container platform
- **🔧 Git** - Version control (with upgrade detection)
- **📗 Node.js** (via nvm) - JavaScript runtime with version management
- **🐍 Python 3** - Python programming language
- **🔷 Go** - Go programming language
- **🦀 Rust** - Rust programming language via rustup
- **💻 Visual Studio Code** - Modern code editor

### 📦 **Optional Categories** (You Choose)

#### Package Managers & Tools
- ✨ **Starship** - Beautiful, fast shell prompt

#### Essential Dev Tools
- 📮 **Postman** - API development and testing
- 🗄️ **DBeaver** - Universal database management

#### Code Quality Tools
- 🪝 **Pre-commit** - Git hooks framework
- ℹ️ ESLint & Prettier (per-project install guidance)

#### Productivity Tools
- 🦇 **bat** - Better `cat` with syntax highlighting
- 📂 **exa** - Modern `ls` replacement
- 🔍 **fzf** - Fuzzy finder for command line
- 📖 **tldr** - Simplified man pages

---

## 🎬 Quick Start

### Prerequisites
- **Linux** (Ubuntu, Debian, or derivatives)
- **curl** installed
- **sudo** access

### Installation

**Option 1: One Command Install (Recommended)**
```bash
curl -fsSL https://raw.githubusercontent.com/one-command/dev-setup/main/install.sh | bash
```

**Option 2: Two-Step Install (More Secure)**
```bash
# Download the installer
curl -fsSL https://raw.githubusercontent.com/one-command/dev-setup/main/install.sh -o install.sh

# Review it (optional)
cat install.sh

# Run it
bash install.sh
```

**Option 3: Direct Script Execution (Advanced)**
```bash
# Download the main script
curl -fsSL https://raw.githubusercontent.com/one-command/dev-setup/main/devsetup.sh -o devsetup.sh

# Review it
cat devsetup.sh

# Make it executable and run
chmod +x devsetup.sh
./devsetup.sh
```

---

## 🧠 Smart Features

### ✅ **Intelligent Detection**
- Checks what's already installed before doing anything
- Won't reinstall or break existing setups
- Shows version comparisons for outdated tools

### 🔄 **Upgrade Prompts**
- Detects outdated software automatically
- Offers to upgrade at the end
- Uses appropriate methods (PPA for Ubuntu, backports for Debian)

### 🎯 **Interactive Selection**
- Ask once, install everything
- No interruptions during installation
- Choose only what you need

### 🎨 **Beautiful Output**
- Color-coded sections
- Progress indicators
- Clear summary of what was installed vs skipped

### 🔒 **Safe & Transparent**
- Pure Bash script - no hidden binaries
- Every action is visible
- Error handling throughout
- Works correctly with piped installation

---

## 📋 Usage Example
```bash
$ curl -fsSL https://raw.githubusercontent.com/one-command/dev-setup/main/install.sh | bash

╔════════════════════════════════════════╗
║                                        ║
║     🚀 One Command Dev Setup 🚀        ║
║                                        ║
╚════════════════════════════════════════╝

📥 Downloading installation script...
✓ Script downloaded successfully!

╔════════════════════════════════════════╗
║                                        ║
║     🚀 Dev Environment Setup 🚀        ║
║                                        ║
╚════════════════════════════════════════╝

Detected OS: Ubuntu

==========================================
  🎯 Installation Preferences
==========================================

This script will install essential development tools.
You can choose which additional categories to install.

📦 Install Package Managers & Tools (Starship)? (y/n): y
🛠️  Install Essential Dev Tools (Postman, DBeaver)? (y/n): y
✨ Install Code Quality Tools (ESLint, Prettier, Pre-commit)? (y/n): n
⚡ Install Productivity Tools (bat, exa, fzf, tldr)? (y/n): y

✅ Preferences saved! Starting installation...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Installing Core Tools...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🐳 Docker Engine & Docker Compose
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Docker Engine 28.5.2 installed ✓
   Docker Compose 2.40.3 installed ✓

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔧 Git
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Git 2.51.2 installed ✓

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📗 Node.js (via nvm)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Node.js 22.14.0 installed ✓
...

╔════════════════════════════════════════╗
║                                        ║
║       ✅ Setup Complete! 🎉            ║
║                                        ║
╚════════════════════════════════════════╝

📥 Newly Installed:
   ✓ Postman
   ✓ Starship
   ✓ bat
   ✓ fzf

✓ Already Installed:
   • Docker Engine 28.5.2
   • Git 2.51.2
   • Node.js 22.14.0
   • Python 3.12.3
   • Go 1.25.4
   • Rust 1.91.1
   • VSCode 1.105.1

📝 Important Notes:
   • Restart your terminal to apply PATH changes
   • Run: source ~/.bashrc to reload your shell

Made by Daniel D - https://www.youtube.com/@one-command

🚀 Happy coding!
```

---

## 🔧 How It Works

### 1. **Smart Wrapper**
The `install.sh` wrapper downloads and executes the main script while properly handling stdin, ensuring interactive prompts work even when piped from curl.

### 2. **OS Detection**
The script automatically detects your Linux distribution (Ubuntu, Debian, etc.) and adapts installation methods accordingly.

### 3. **Smart Checking**
Before installing anything, it checks:
- Is the tool already installed?
- What version is currently installed?
- Is there a newer version available?

### 4. **Best Installation Methods**
- **Docker**: Official Docker repositories
- **Node.js**: NVM for version management
- **Go & VSCode**: Snap (with apt fallback)
- **Rust**: Official rustup installer
- **Python**: System package manager
- **Dev Tools**: Snap packages for easy updates

### 5. **PATH Management**
Automatically updates your `.bashrc` and `.profile` to include newly installed tools in your PATH.

### 6. **Cleanup & Verification**
- Removes broken repositories
- Verifies installations succeeded
- Provides clear summary of what was done

---

## 🐧 Supported Systems

| OS | Version | Status |
|---|---|---|
| Ubuntu | 20.04+ | ✅ Fully Supported |
| Ubuntu | 22.04+ | ✅ Fully Supported |
| Ubuntu | 24.04+ | ✅ Fully Supported |
| Debian | 11+ | ✅ Fully Supported |
| Debian | 12+ | ✅ Fully Supported |
| Other Debian-based | - | ⚠️ Should work, not tested |

---

## 🤔 FAQ

### **Is this safe?**
Yes! The script is:
- Open source - you can read every line
- Non-destructive - checks before installing
- Well-tested on Ubuntu and Debian
- Uses official installation methods

### **Why use the wrapper script?**
The `install.sh` wrapper ensures interactive prompts work correctly when piping from curl. It downloads the main script and executes it with proper terminal handling.

### **Can I customize what gets installed?**
Absolutely! The script asks you interactively, or you can fork it and modify the code directly.

### **What if something fails?**
The script has error handling and will continue even if one tool fails. Check the summary at the end to see what succeeded.

### **Will it break my existing setup?**
No. The script detects existing installations and skips them. It won't overwrite or reconfigure without asking.

### **Can I run it multiple times?**
Yes! It's idempotent - running it again will only install what's missing or upgrade outdated tools (if you choose).

### **Do I need to restart after installation?**
For PATH changes to take effect:
```bash
source ~/.bashrc
```
For Docker group changes (if Docker was just installed), log out and back in.

---

## 🛠️ Troubleshooting

### **Interactive prompts not working**
Make sure you're using the `install.sh` wrapper, not the direct `devsetup.sh` script when piping from curl:
```bash
# ✅ Correct
curl -fsSL https://raw.githubusercontent.com/one-command/dev-setup/main/install.sh | bash

# ❌ Won't work with interactive prompts when piped
curl -fsSL https://raw.githubusercontent.com/one-command/dev-setup/main/devsetup.sh | bash
```

### **Go or Rust command not found**
Restart your terminal or run:
```bash
source ~/.bashrc
```

### **Docker permission denied**
Log out and back in for group changes to take effect, or run:
```bash
newgrp docker
```

### **Git upgrade didn't work**
On Debian, the latest Git version may not be available in standard repos. The script uses backports, but you may need to build from source for the absolute latest.

### **Snap installations failing**
Some minimal Ubuntu installations don't have snapd. The script will try to install it automatically, but you may need to run:
```bash
sudo apt update
sudo apt install snapd
```

---

## 🤝 Contributing

Contributions are welcome! Feel free to:
- 🐛 Report bugs
- 💡 Suggest features
- 🔧 Submit pull requests
- ⭐ Star the repo if you find it useful

### Development
```bash
# Clone the repo
git clone https://github.com/one-command/dev-setup.git
cd dev-setup

# Make changes to devsetup.sh or install.sh

# Test on a fresh VM
./install.sh
# or
./devsetup.sh
```

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Credits

Made with ❤️ by **Daniel D**

This script automates best practices from the developer community. Special thanks to all the maintainers of the tools included.

---

## 📺 Learn More

Want to see this in action? Check out the full tutorial on YouTube:

[![One Command YouTube Channel](https://img.shields.io/badge/▶️_Subscribe-One_Command-red?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@one-command)

**One Command** - Where we turn complicated workflows into single commands. No subscriptions. No nonsense. Just automation.

---

<div align="center">

**[⬆ Back to Top](#-one-command-dev-setup)**

Made by [Daniel D](https://github.com/one-command) | [YouTube](https://www.youtube.com/@one-command)

</div>