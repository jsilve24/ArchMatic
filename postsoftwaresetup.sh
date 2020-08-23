#!/usr/bin/env bash
#-------------------------------------------------------------------------
#      _          _    __  __      _   _
#     /_\  _ _ __| |_ |  \/  |__ _| |_(_)__
#    / _ \| '_/ _| ' \| |\/| / _` |  _| / _|
#   /_/ \_\_| \__|_||_|_|  |_\__,_|\__|_\__|
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

echo "-------------------------------------------------"
echo "Setting up software                              "
echo "-------------------------------------------------"

# Configure awesome-wm
git clone https://github.com/ChrisTitusTech/material-awesome.git ~/.config/awesome

lxappearance

sed -i 's/^gtk-theme-name=Adwaita/gtk-theme-name=Materia-dark/' ~/.config/gtk-3.0/settings.ini
sed -i 's/^gtk-icon-theme-name=Adwaita/gtk-icon-theme-name=Papirus-Dark/' ~/.config/gtk-3.0/settings.ini

echo 'awesome.restart()' | awesome-client

# Configure zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

yay -S powerline-fonts fzf --noconfirm --needed

sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc
git clone git://github.com/sigurdga/gnome-terminal-colors-solarized.git ~/.solarized
sh ~/.solarized/install.sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

mv ~/.zshrc .zshrc.bak
mv .zshrc ~/.zshrc
