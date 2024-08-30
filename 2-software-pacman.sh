#!/usr/bin/env bash
#-------------------------------------------------------------------------
#      _          _    __  __      _   _
#     /_\  _ _ __| |_ |  \/  |__ _| |_(_)__
#    / _ \| '_/ _| ' \| |\/| / _` |  _| / _|
#   /_/ \_\_| \__|_||_|_|  |_\__,_|\__|_\__|
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

echo
echo "INSTALLING SOFTWARE"
echo

PKGS=(

    # SYSTEM --------------------------------------------------------------

    # 'linux-lts'             # Long term support kernel

    # TERMINAL UTILITIES --------------------------------------------------

    'curl'                    # Remote content retrieval
    'htop'                    # Process viewer
    'rsync'                   # Remote file sync utility
    'unrar'                   # RAR compression program
    'unzip'                   # Zip compression program
    'wget'                    # Remote content retrieval
    'terminator'              # Terminal emulator
    'zsh'                     # Interactive shell
    'zsh-autosuggestions'     # Zsh Plugin
    'zsh-syntax-highlighting' # Zsh Plugin

    # GENERAL UTILITIES ---------------------------------------------------

    'plocate'
    'emacs-nativecomp'
    'hplip' 		      # hp laserjet drivers for office printer
    'thermald'		      # better performance when avoiding overheating
    'powertop'		      # system monitor focused on battery life

    # i3  -----------------------------------------------------------------

    'i3-wm'
    'i3status'
    'dmenu'
    'arandr'
    'autorandr'
    'jq'
    'xdotool'

    # DEVELOPMENT ---------------------------------------------------------

    # 'clang'                 # C Lang compiler
    'cmake'                 # Cross-platform open-source make system
    'git'                   # Version control system
    'gcc'                   # C/C++ compiler
    # 'glibc'                 # C libraries
    'npm'                   # Node package manager, needed for hugo

    # Stuff for R
    'r'
    'tcl'
    'libgit2'
    'gcc-fortran'
    'openmp'
    'openssl-1.1'
    'icu' 			# needed for stringr I think
    'glpk' 			# needed for igraph


    # Stuff for Python
    'python-pip'              # Scripting language
    'python-scikit-learn'
    'python-matplotlib'
    'pandas'
    'jupyter-notebook'
    
    # WACOM ---------------------------------------------------------------

    'xf86-input-wacom'        # to get xsetwacom

    # PRODUCTIVITY --------------------------------------------------------

    'aspell'              # Spellcheck libraries
    'aspell-en'           # English spellcheck library
    'inotify-tools'       # Used by exwm-qute-edit script
    'libreoffice-still'
    'inkscape'
    'gimp'
    'spotify'
    'textext'             # latex in inkscape
    'hugo'
    
    # Sound --------------------------------------------------------------- 

    # no microphone detected, try installing sof-firmware and alsa-ucm-conf from here: https://bbs.archlinux.org/viewtopic.php?id=258633
    'alsa-utils'
    'pulseaudio'
    'pulseaudio-alsa'
    'pamixer'

)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done


echo
echo "Done!"
echo
