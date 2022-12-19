#!/usr/bin/env bash
#-------------------------------------------------------------------------
#      _          _    __  __      _   _
#     /_\  _ _ __| |_ |  \/  |__ _| |_(_)__
#    / _ \| '_/ _| ' \| |\/| / _` |  _| / _|
#   /_/ \_\_| \__|_||_|_|  |_\__,_|\__|_\__|
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

echo "-------------------------------------------------"
echo "Secure Linux                                     "
echo "-------------------------------------------------"

# --- Setup UFW rules
ufw allow 80/tcp
ufw allow 443/tcp
ufw default deny incoming  
ufw default allow outgoing
ufw enable

# --- Harden /etc/sysctl.conf
sysctl kernel.modules_disabled=1
sysctl -a
sysctl -A
sysctl mib
sysctl net.ipv4.conf.all.rp_filter
sysctl -a --pattern 'net.ipv4.conf.(eth|wlan)0.arp'

# --- PREVENT IP SPOOFS
cat <<EOF > /etc/host.conf
order bind,hosts
multi on
EOF

# --- Enable ufw
systemctl enable ufw
systemctl start ufw

# --- Enable fail2ban
curl https://raw.githubusercontent.com/johnynfulleffect/secure-linux/master/jail.local -o /etc/fail2ban/jail.local
systemctl enable fail2ban
systemctl start fail2ban
