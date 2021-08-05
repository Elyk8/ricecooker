#!/bin/sh

sudo timedatectl set-ntp true
sudo hwclock --systohc
sudo reflector -c Australia -c "New Zealand" -a 12 -p https -p http --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syu --noconfirm

sudo pacman -S --noconfirm acpilight xorg sx simplescreenrecorder ttf-bitstream-vera ttf-dejavu ttf-liberation ttf-devicons ttf-linux-libertine noto-fonts tex-gyre-fonts ttf-jetbrains-mono adobe-source-code-pro-fonts noto-fonts-cjk noto-fonts-emoji
sudo pacman -S --noconfirm zathura zathura-pdf-mupdf calcurse dash dunst exa feh flameshot inkscape lxappearance-gtk3 lxsession-gtk3 mpc mpd mpv ncmpcpp wmctrl lazygit newsboat redshift rofi rofi-pass trash-cli interception-dual-function-keys

sudo systemctl enable --now udevmon.service

# AUR packages
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
paru -S --noconfirm beautyline brave-bin dragon-drag-and-drop gotop-bin lf mpd-notification-git mutt-wizard nerd-fonts-jetbrains-mono nerd-fonts-monoki pfetch zramd

git config --global credential.helper cache

# Deploy my dotfiles
sudo rm -r $HOME/.config $HOME/.local/bin $HOME/.local/share/applications
mkdir -p $HOME/.local/share/dotrice
git clone --bare https://github.com/Elyk8/dotrice.git $HOME/.local/share/dotrice
alias rice='/usr/bin/git --git-dir=$HOME/.local/share/dotrice --work-tree=$HOME'
rice --local status.showUntrackedFiles no
rice checkout

# Install suckless tools
mkdir -p $HOME/.local/src
cd $HOME/.local/src
git clone https://github.com/Elyk8/dwm.git
git clone https://github.com/Elyk8/dwmblocks.git
git clone https://github.com/Elyk8/dmenu.git
git clone https://github.com/Elyk8/st.git
git clone https://github.com/Elyk8/sxiv
cd dwm && sudo make clean install
cd ../dwmblocks && sudo make clean install
cd ../dmenu && sudo make clean install
cd ../st && sudo make clean install
cd ../sxiv && sudo make clean install
cd

# Install lunarvim (WIP)
cd $HOME/.config
git clone https://github.com/Elyk8/lvim.git
cd

# Change to dash
sudo ln -sfT dash /usr/bin/sh
sudo cp ./pachooks/bash-update.hook /usr/share/libalpm/hooks

/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
sudo reboot
