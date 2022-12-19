# ArchMatic Installer Script

This README contains the steps I do to install and configure a fully-functional Arch Linux installation containing a desktop environment, all the support packages (network, bluetooth, audio, etc.), along with all my preferred applications and utilities. The shell scripts in this repo allow the entire process to be automated.)

---

## Setup Boot and Arch ISO on USB key

First, setup the boot USB, boot arch live iso, and run the `preinstall.sh` from terminal. 

### Arch Live ISO (Pre-Install)

This step installs arch to your hard drive. *IT WILL FORMAT THE DISK*

```bash
curl https://raw.githubusercontent.com/johnynfulleffect/ArchMatic/master/preinstall.sh -o preinstall.sh
sh preinstall.sh

useradd -m -G users,wheel username
echo "username:password" | chpasswd
passwd
systemctl enable NetworkManager
exit

umount -R /mnt
reboot
```

### Arch Linux First 

```bash
pacman -S --noconfirm pacman-contrib curl git
git clone https://github.com/johnynfulleffect/ArchMatic
cd ArchMatic
sh 0-setup.sh
sh 1-base.sh
sh 2-software-pacman.sh
su username
sh 3-software-aur.sh
su
sh 4-secure-system.sh
sh 9-post-setup.sh
```

### System Description
This runs Awesome Window Manager with the base configuration from the Material-Awesome project <https://github.com/ChrisTitusTech/material-awesome>.

To boot I use `systemd` because it's minimalist, comes built-in, and since the Linux kernel has an EFI image, all we need is a way to execute it.

I also install the LTS Kernel along side the rolling one, and configure my bootloader to offer both as a choice during startup. This enables me to switch kernels in the event of a problem with the rolling one.

### Troubleshooting Arch Linux

__[Arch Linux Installation Gude](https://github.com/rickellis/Arch-Linux-Install-Guide)__
