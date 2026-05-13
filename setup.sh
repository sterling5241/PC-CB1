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
cd /home/biqu
sudo -u biqu git clone https://github.com/dw-0/kiauh.git

# Run all installs as biqu
sudo -u biqu bash <<'BIQU'

cd /home/biqu

# Klipper
git clone https://github.com/Klipper3d/klipper.git
./klipper/scripts/install-debian.sh

# Moonraker
git clone https://github.com/Arksine/moonraker.git
./moonraker/scripts/install-moonraker.sh

# Mainsail
mkdir -p /home/biqu/mainsail
cd /home/biqu/mainsail
wget -q -O mainsail.zip https://github.com/mainsail-crew/mainsail/releases/latest/download/mainsail.zip
unzip -q mainsail.zip
rm mainsail.zip
cd /home/biqu

# Crowsnest
git clone https://github.com/mainsail-crew/crowsnest.git
cd crowsnest && make install
cd /home/biqu

BIQU

echo "=== Setup Complete ==="
echo "Access Mainsail at: http://$(hostname -I | awk '{print $1}')"
