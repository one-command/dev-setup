#!/usr/bin/env python3
"""
One Command Dev Setup - Interactive Installer
Made by Daniel D - https://www.youtube.com/@one-command
"""

import os
import sys
import subprocess
import urllib.request
import tempfile
import stat

def main():
    print("\033[96m╔════════════════════════════════════════╗\033[0m")
    print("\033[96m║                                        ║\033[0m")
    print("\033[96m║     🚀 One Command Dev Setup 🚀        ║\033[0m")
    print("\033[96m║                                        ║\033[0m")
    print("\033[96m╚════════════════════════════════════════╝\033[0m")
    print()
    print("\033[93mDownloading installation script...\033[0m")
    
    # GitHub raw URL for the bash script
    script_url = "https://raw.githubusercontent.com/one-command/dev-setup/main/devsetup.sh"
    
    try:
        # Download the script
        with urllib.request.urlopen(script_url) as response:
            script_content = response.read().decode('utf-8')
        
        # Create a temporary file
        with tempfile.NamedTemporaryFile(mode='w', suffix='.sh', delete=False) as temp_file:
            temp_file.write(script_content)
            temp_script_path = temp_file.name
        
        # Make the script executable
        os.chmod(temp_script_path, stat.S_IRWXU | stat.S_IRGRP | stat.S_IXGRP | stat.S_IROTH | stat.S_IXOTH)
        
        print("\033[92m✓ Script downloaded successfully!\033[0m")
        print()
        
        # Execute the script with proper terminal handling
        try:
            subprocess.run(['/bin/bash', temp_script_path], check=True)
        except subprocess.CalledProcessError as e:
            print(f"\033[91m✗ Installation failed with error code {e.returncode}\033[0m")
            sys.exit(e.returncode)
        except KeyboardInterrupt:
            print("\n\033[93m⚠️  Installation cancelled by user\033[0m")
            sys.exit(130)
        finally:
            # Cleanup temporary file
            try:
                os.unlink(temp_script_path)
            except:
                pass
                
    except urllib.error.URLError as e:
        print(f"\033[91m✗ Failed to download script: {e}\033[0m")
        print("\033[93mPlease check your internet connection and try again.\033[0m")
        sys.exit(1)
    except Exception as e:
        print(f"\033[91m✗ Unexpected error: {e}\033[0m")
        sys.exit(1)

if __name__ == "__main__":
    # Check if running as root
    if os.geteuid() == 0:
        print("\033[91m✗ Please do not run this script as root or with sudo\033[0m")
        print("\033[93m  The script will ask for sudo password when needed\033[0m")
        sys.exit(1)
    
    main()