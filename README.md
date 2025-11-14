# 🚀 One Command Dev Setup

[![Watch the Tutorial](https://img.shields.io/badge/▶️_Watch-Tutorial-red?style=for-the-badge&logo=youtube)](https://www.youtube.com/@one-command)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Debian](https://img.shields.io/badge/Debian-D70A53?style=for-the-badge&logo=debian&logoColor=white)](https://www.debian.org/)

> **Set up your entire development environment with a single command.** No manual installations, no configuration headaches, no hours wasted. Just one line and you're ready to code.
```bash
curl -s https://raw.githubusercontent.com/one-command/dev-setup/main/devsetup.sh | bash
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

**Option 1: Direct Install (Recommended)**
```bash
curl -s https://raw.githubusercontent.com/one-command/dev-setup/main/devsetup.sh | bash
```

**Option 2: Review First (Security Conscious)**
```bash
# Download and inspect the script
curl -s https://raw.githubusercontent.com/one-command/dev-setup/main/devsetup.sh > devsetup.sh

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

---

## 📋 Usage Example
```bash
$ curl -s https://raw.githubusercontent.com/one-command/dev-setup/main/devsetup.sh | bash

╔════════════════════════════════════════╗
║                                        ║
║     🚀 Dev Environment Setup 🚀        ║
║                                        ║
╚════════════════════════════════════════╝

Detected OS: Ubuntu

==========================================
  🎯 Installation Preferences
==========================================

📦 Install Package Managers & Tools (Starship)? (y/n): y
🛠️  Install Essential Dev Tools (Postman, DBeaver)? (y/n): y
✨ Install Code Quality Tools (ESLint, Prettier, Pre-commit)? (y/n): n
⚡ Install Productivity Tools (bat, exa, fzf, tldr)? (y/n): y

✅ Preferences saved! Starting installation...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Installing Core Tools...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🐳 Docker Engine 28.5.2 installed ✓
🔧 Git 2.51.2 installed ✓
📗 Node.js 22.14.0 installed ✓
...

╔════════════════════════════════════════╗
║                                        ║
║       ✅ Setup Complete! 🎉            ║
║                                        ║
╚════════════════════════════════════════╝
```

---

## 🔧 How It Works

### 1. **OS Detection**
The script automatically detects your Linux distribution (Ubuntu, Debian, etc.) and adapts installation methods accordingly.

### 2. **Smart Checking**
Before installing anything, it checks:
- Is the tool already installed?
- What version is currently installed?
- Is there a newer version available?

### 3. **Best Installation Methods**
- **Docker**: Official Docker repositories
- **Node.js**: NVM for version management
- **Go & VSCode**: Snap (with apt fallback)
- **Rust**: Official rustup installer
- **Python**: System package manager

### 4. **PATH Management**
Automatically updates your `.bashrc` and `.profile` to include newly installed tools in your PATH.

### 5. **Cleanup & Verification**
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

# Make changes to devsetup.sh

# Test on a fresh VM
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