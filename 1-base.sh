#!/usr/bin/env bash
#-------------------------------------------------------------------------
#      _          _    __  __      _   _
#     /_\  _ _ __| |_ |  \/  |__ _| |_(_)__
#    / _ \| '_/ _| ' \| |\/| / _` |  _| / _|
#   /_/ \_\_| \__|_||_|_|  |_\__,_|\__|_\__|
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

echo
echo "Installing Base System"
echo

PKGS=(

    # --- XORG Display Rendering
        'xorg-server'           # XOrg server
	'xorg-xrandr'
        'xorg-xinit'            # XOrg init
	'xorg-xsetroot'
	'acpilight'       # provides xbacklight command
        'xterm'                 # Terminal for TTY
	'alacritty'
	'git'
	'git-lfs'

    # --- Setup Utilities
	'fzf' 			# fuzzy finder used by zoxide
	'neovim'
	# 'xclip'                 # for neovim

    # --- Networking Setup
        'networkmanager'            # Network connection manager
	'network-manager-applet'    # to setup WPA2 Enterprise connections (psu)
	'net-tools'
	'inetutils'
	'iwd'

    # --- Browsers
	'qutebrowser'
	'pdfjs-legacy'            #  legacy pdfjs support until Q6 is supported

    # --- Bluetooth
        # 'bluez'                 # Daemons for the bluetooth protocol stack
        # 'bluez-utils'           # Bluetooth development and debugging utilities
        # 'bluez-libs'            # Bluetooth libraries
        # 'bluez-firmware'        # Firmware for Broadcom BCM203x and STLC2300 Bluetooth chips
        # 'blueberry'             # Bluetooth configuration tool
        # 'pulseaudio-bluetooth'  # Bluetooth support for PulseAudio
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo
echo "Done!"
echo
