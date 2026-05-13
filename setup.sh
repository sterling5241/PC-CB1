#!/bin/bash
set -e

echo "=== MINIPC-CB1 Setup ==="

# Set hostname
echo "MINIPC-CB1" > /etc/hostname
hostname MINIPC-CB1

# Set root password
echo "root:root" | chpasswd

# Create biqu user with password biqu
useradd -m -s /bin/bash biqu 2>/dev/null || true
echo "biqu:biqu" | chpasswd
usermod -aG sudo,tty,dialout,video biqu

# Auto login at startup (no password prompt)
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat <<EOF > /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin biqu --noclear %I \$TERM
EOF

# Update system
apt-get update && apt-get upgrade -y

# Install dependencies
apt-get install -y git python3 python3-pip python3-venv virtualenv nginx curl wget

# Install KIAUH
cd /root
git clone https://github.com/dw-0/kiauh.git

# Auto install Klipper, Moonraker, Mainsail, Crowsnest
bash /root/kiauh/scripts/install-klipper.sh
bash /root/kiauh/scripts/install-moonraker.sh
bash /root/kiauh/scripts/install-mainsail.sh
bash /root/kiauh/scripts/install-crowsnest.sh

echo "=== Setup Complete ==="
echo "Access Mainsail at: http://$(hostname -I | awk '{print $1}')"
