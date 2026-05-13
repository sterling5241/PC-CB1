#!/bin/bash
set -e

echo "=== MINIPC-CB1 Setup ==="

# Hostname
echo "MINIPC-CB1" > /etc/hostname
hostname MINIPC-CB1

# Update
apt-get update && apt-get upgrade -y

# Dependencies
apt-get install -y git python3 python3-pip python3-venv virtualenv nginx curl wget

# Create user
useradd -m -s /bin/bash klipper 2>/dev/null || true
usermod -aG tty,dialout,video klipper

# Install KIAUH
cd /home/klipper
sudo -u klipper git clone https://github.com/dw-0/kiauh.git

echo "=== Run KIAUH manually ==="
echo "su - klipper"
echo "~/kiauh/kiauh.sh"
echo ""
echo "Install: 1) Klipper  2) Moonraker  3) Mainsail"
