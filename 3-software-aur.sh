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


package="yay";
check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
if [ -n "${check}" ] ; then
    echo "${package} is installed";
elif [ -z "${check}" ] ; then
    echo "${package} is NOT installed";
    echo "CLONING: YAY"
    git clone "https://aur.archlinux.org/yay.git"
    cd ${HOME}/yay
    makepkg -si
fi;


PKGS=(

    # UTILITIES -----------------------------------------------------------

    'timeshift'                 # Backup and Restore
    'borg'
    'python-llfuse'             # required for borg
    'ly'			# Display Manager
    'zoxide'
    'kmonad'
    'gnupg'
    'pam-gnupg'
    'xournalpp'
    'globalprotect-openconnect' # for PSU vpn
    'zoom'
    'auto-cpufreq'	
    'zotero-translation-server-git'
    'spotify'
    'bashmount' 		# easy mounting and unmounting 
    'ical2orgpy-git'
    'google-chrome'
    'hunspell-en_us'		# required by libreoffice (hunspell installed in pacman file)

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
    'ttf-fira-sans'		# for metropolis beamer theme
    'ttf-hack'
    'ttf-jetbrains-mono' 

    # UTILS For Emacs -----------------------------------------------------

    'words'
    # 'wordnet-common'
    # 'wordnet-cli'
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
    'ripgrep-all'
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
    'slack-desktop'

    # LATEX --------------------------------------------------------------

    'texlive-basic'
    'texlive-latex'
    'texlive-latexextra'
    'texlive-bibtexextra'
    'texlive-fontsrecommended'
    'texlive-fontsextra'
    'texlive-plaingeneric' # contains ulem.sty
    'texlive-binextra' # pdfjam command for merging/splitting pdf files
    'texlive-mathscience'	# needed for algorithm.sty
    'biber'
    # 'texlive-science' 

    # R ------------------------------------------------------------------

    'libxls'
    'udunits'
    # 'r-devtools'
    # 'r-tidyverse'
    # 'r-rcpp'
    # 'r-languageserver'
    # 'r-lintr'
    # 'r-usethis'
    # 'r-pkgdown'
    # 'r-rstan'
    # 'r-progress'
    # 'r-philr'
    # 'r-aldex2'

    # Python -------------------------------------------------------------


    # PRINTING -----------------------------------------------------------
    
    'cups'
    # ppd file gets installed to /opt/brother/Printers/HLL2380DW/cupswrapper/brother-HLL2380DW-cups-en.ppd
    'brother-hl-l2380dw' 
    'avahi'			# to get network discovery 
    'nss-mdns'			# For Hostname Resolution
)

# Change default shell
# chsh -s $(which zsh)

for PKG in "${PKGS[@]}"; do
    yay -S --noconfirm $PKG
done

echo
echo "Done!"
echo
