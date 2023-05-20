#!/usr/bin/env bash
#-------------------------------------------------------------------------
#      _          _    __  __      _   _
#     /_\  _ _ __| |_ |  \/  |__ _| |_(_)__
#    / _ \| '_/ _| ' \| |\/| / _` |  _| / _|
#   /_/ \_\_| \__|_||_|_|  |_\__,_|\__|_\__|
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------


echo
echo "Copying Over Secrets"
echo 
echo "Bitwarden Username:"
read username
cd 
sessionkey=$(bw login $username --raw)
export BW_SESSION=$sessionkey
bw get attachment --itemid ee3eb1eb-4f27-409a-a0b4-ae8101526b43 .netrc.gpg
bw get attachment --itemid ee3eb1eb-4f27-409a-a0b4-ae8101526b43 .pam-gnupg
bw get attachment --itemid ee3eb1eb-4f27-409a-a0b4-ae8101526b43 .org-caldav-secrets.el.gpg
bw get attachment --itemid ee3eb1eb-4f27-409a-a0b4-ae8101526b43 .psu_mailpass.gpg
bw get attachment --itemid ee3eb1eb-4f27-409a-a0b4-ae8101526b43 .bw_secret.gpg
bw get attachment --itemid ee3eb1eb-4f27-409a-a0b4-ae8101526b43 .authinfo.gpg
bw get attachment --itemid ee3eb1eb-4f27-409a-a0b4-ae8101526b43 .gmail_mailpass.gpg
bw get attachment --itemid ee3eb1eb-4f27-409a-a0b4-ae8101526b43 .gnupg.tar.gz
tar -zxvf .gnupg.tar.gz


echo
echo "Enabling plocate"
echo
sudo systemctl enable plocate-updatedb.timer

echo
echo "Enabling Printing"
echo 
sudo bash -c 'cat <<EOF > /etc/nsswitch.conf
# Name Service Switch configuration file.
# See nsswitch.conf(5) for details.

passwd: files systemd
group: files [SUCCESS=merge] systemd
shadow: files systemd
gshadow: files systemd

publickey: files

hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

netgroup: files
EOF'

sudo systemctl enable --now avahi-daemon.service
sudo systemctl enable --now cups.service



echo 
echo "INSTALLING DOTFILES"
echo 
git lfs install
git clone https://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
cd $HOME/.homesick/repos/homeshick 
./homeshick clone https://github.com/jsilve24/arch-dotfiles.git
./homeshick link arch-dotfiles



echo 
echo "Downloading zsh plugins"
echo

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# move my .zshrc back and replace the one writen by oh-my-zsh
# install plugins
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
git clone https://github.com/micrenda/zsh-nohup ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/nohup

echo 
echo "Setting up KMonad"
echo
cd $HOME/.homeschick/repos/arch-dotfiles/home/.config/kmonad
sudo cp kmonad-kinesis.service /etc/systemd/system/kmonad-kinesis.service
sudo cp kmonad-lenovo.service /etc/systemd/system/kmonad-lenovo.service
sudo systemctl enable --now kmonad-kinesis.service
sudo systemctl enable --now kmonad-lenovo.service

echo
echo "Setting up Ly Display Manager"
echo
sudo systemctl enabel ly.service
sudo bash -c 'cat <<EOF > /etc/pam.d/ly
#%PAM-1.0

auth       include      login
account    include      login
password   include      login
session    include      login
auth     optional  pam_gnupg.so store-only
session  optional  pam_gnupg.so
EOF'
gpgconf --reload gpg-agent

echo
echo "Setting up EXWM"
echo 
sudo bash -c 'cat<<EOF > /usr/share/xsessions/emacs.desktop 
[Desktop Entry]
Name=Emacs
Exec=emacs
Type=Application
EOF'


echo
echo "Linking dragon-drop to dragon"
echo
ln -s /sbin/dragon-drop /home/jds6696/bin/dragon

echo 
echo "Install ical2orgpy"
echo 
pip install ical2orgpy

echo 
echo "INSTALLING .emacs.d"
echo 
git clone https://github.com/jsilve24/.emacs.d.git $HOME/.emacs.d/

echo 
echo "Starting Mail Download"
echo 
mkdir ~/.mail
mkdir ~/.mail/psu
mkdir ~/.mail/gmail
davmail &
mu init --maildir=.mail --my-address=jsilve24@gmail.com --my-address=JustinSilverman@psu.edu
mu index
mbsync -a


echo 
echo "Setup Hugo and npm"
echo 
npm install postcss postcss-cli autoprefixer


echo 
echo "Giving User Backlight Privledges"
echo 
sudo touch /etc/udev/rules.d/backlight.rules
sudo bash -c 'cat << EOF > /etc/udev/rules.d/backlight.rules
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
EOF'
sudo usermod -aG video jds6696

echo
echo "Enabling and Starting zotero-translation-server service"
echo
sudo systemctl enable --now zotero-translation-server.service
