#!/usr/bin/env bash
#-------------------------------------------------------------------------
#      _          _    __  __      _   _
#     /_\  _ _ __| |_ |  \/  |__ _| |_(_)__
#    / _ \| '_/ _| ' \| |\/| / _` |  _| / _|
#   /_/ \_\_| \__|_||_|_|  |_\__,_|\__|_\__|
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

echo
echo "INSTALLING AUR SOFTWARE"
echo

# echo "Please enter username:"
# read username

cd "${HOME}"

echo "CLONING: YAY"
git clone "https://aur.archlinux.org/yay.git"


PKGS=(

    # UTILITIES -----------------------------------------------------------

    'timeshift'                 # Backup and Restore
    'borg'
    'python-llfuse'             # required for borg
    'ly'			# Display Manager
    'zoxide'
    'kmonad-bin'
    'gnupg'
    'xournalpp'
    'globalprotect-openconnect' # for PSU vpn

    # FILES ---------------------------------------------------------------

    'dropbox'
    'bitwarden'
    'bitwarden-cli'
    'rsync'
    'github-cli'

    # FONTS ---------------------------------------------------------------

    'cantarell-static-fonts'
    'ttf-dejavu'
    'ttf-fira-code'
    'ttf-hack'
    'ttf-jetbrains-mono' 

    # UTILS For Emacs -----------------------------------------------------

    'words'
    'wordnet-common'
    'wordnet-cli'
    'global'
    'ctags'
    'libvterm'
    'dragon-drop'
    'scrot'
    'libpng'
    'zlib'
    'poppler-glib'
    'pandoc'
    'ripgrep'
    'repgrep-all'
    'imagemagick'
    'perl-image-exiftool'  	# used by org-bib-mode
    'xdo' 			# used by org-protocol

    # Mail ---------------------------------------------------------------

    'autoconf'
    'automake'
    'pkg-config'
    'mu'
    'isync'
    'davmail'

    # LATEX --------------------------------------------------------------

    'texlive-core'
    'texlive-fontsextra'
    'texlive-latexextra'
    'biber'
    'texlive-bibtexextra'
    'texlive-science' 

    # R ------------------------------------------------------------------

    'libxls'
    'udunits'

    # PRINTING -----------------------------------------------------------
    
    'cups'
    # ppd file gets installed to /opt/brother/Printers/HLL2380DW/cupswrapper/brother-HLL2380DW-cups-en.ppd
    'brother-hl-l2380dw' 
    'avahi'			# to get network discovery 
    'nss-mdns'			# For Hostname Resolution
)

cd ${HOME}/yay
makepkg -si

# Change default shell
chsh -s $(which zsh)

for PKG in "${PKGS[@]}"; do
    yay -S --noconfirm $PKG
done

echo
echo "Done!"
echo
