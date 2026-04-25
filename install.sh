#!/usr/bin/env bash
# install.sh — EvilURL dependency installer
# Supports Kali/Ubuntu/Debian, Arch/BlackArch, Fedora/RHEL, and macOS

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[*] EvilURL — Dependency Installer"
echo "[*] Detecting platform..."

install_pip_deps() {
    echo "[*] Installing Python dependencies from requirements.txt..."
    pip3 install -r "$SCRIPT_DIR/requirements.txt" --break-system-packages 2>/dev/null \
        || pip3 install -r "$SCRIPT_DIR/requirements.txt" --user \
        || pip3 install -r "$SCRIPT_DIR/requirements.txt"
    echo "[+] Python dependencies installed."
}

if command -v apt-get &>/dev/null; then
    # Kali / Ubuntu / Debian / Parrot
    echo "[*] Detected apt-based system (Kali/Debian/Ubuntu/Parrot)"
    sudo apt-get update -qq
    sudo apt-get install -y python3 python3-pip nmap
    install_pip_deps

elif command -v pacman &>/dev/null; then
    # Arch / BlackArch / Manjaro
    echo "[*] Detected pacman-based system (Arch/BlackArch)"
    sudo pacman -S --noconfirm --needed python python-pip nmap
    install_pip_deps

elif command -v dnf &>/dev/null; then
    # Fedora / RHEL / CentOS Stream
    echo "[*] Detected dnf-based system (Fedora/RHEL)"
    sudo dnf install -y python3 python3-pip nmap
    install_pip_deps

elif command -v brew &>/dev/null; then
    # macOS with Homebrew
    echo "[*] Detected macOS (Homebrew)"
    brew install python3 nmap
    install_pip_deps

else
    echo "[!] Unknown package manager. Please install python3, pip3, and nmap manually."
    echo "[!] Then run: pip3 install -r requirements.txt"
    exit 1
fi

echo ""
echo "[+] Installation complete."
echo ""
echo "=== Usage Examples ==="
echo ""
echo "  Generate evil lookalike domains for a target:"
echo "    python3 evilurl.py -g -d google.com"
echo ""
echo "  Generate and check domain availability:"
echo "    python3 evilurl.py -g -d google.com -a"
echo ""
echo "  Check if a suspicious URL contains IDN homograph chars:"
echo "    python3 evilurl.py -d gооgle.com"
echo ""
echo "  Check a list of URLs from a file:"
echo "    python3 evilurl.py -f urls.txt"
echo ""
echo "  Save output to a file:"
echo "    python3 evilurl.py -g -d apple.com -o results.txt"
echo ""
echo "  Test domain connectivity (requires root/nmap):"
echo "    sudo python3 evilurl.py -g -d paypal.com -c"
echo ""
