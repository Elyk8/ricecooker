#
# Makefile for dotfiles
#
# You can use this Makefile to install individual dotfiles or install all of
# them at once. Each makefile rule first cleans the exisiting dotfile by
# removing it and replacing it.
#
# !!! Make sure you backup your stuff first !!!
#

SHELL						=	/bin/bash
PACMAN					:= sudo pacman -S --needed
PARU						:= paru -S
SYSTEMD_ENABLE	:= sudo systemctl --now enable

BASEPKGS := acpilight xorg-server xorg-apps sx simplescreenrecorder ttf-bitstream-vera
BASEPKGS += ttf-dejavu ttf-liberation ttf-linux-libertine noto-fonts tex-gyre-fonts
BASEPKGS += ttf-jetbrains-mono adobe-source-code-pro-fonts noto-fonts-cjk noto-fonts-emoji
BASEPKGS += zathura zathura-pdf-mupdf calcurse dunst exa feh flameshot inkscape
BASEPKGS += lxappearance-gtk3 lxsession-gtk3 mpc mpd mpv ncmpcpp wmctrl lazygit newsboat
BASEPKGS += redshift rofi rofi-pass trash-cli

AURPKGS := beautyline brave-bin dragon-drag-and-drop gotop-bin lf-bin
AURPKGS += mpd-notification-git mutt-wizard nerd-fonts-jetbrains-mono
AURPKGS += pfetch zramd ttf-twemoji libxft-bgra-git ttf-devicons nerd-fonts-monoki 
AURPKGS += xcwd-git

.DEFAULT_GOAL := help

help:
	@echo 'Makefile for dotfiles                                                    '
	@echo '                                                                         '
	@echo 'Usage:                                                                   '
	@echo '   make all                          install everything                  '
	@echo '   make setup                        initial system setup                '
	@echo '   make base                         install base packages               '
	@echo '   make aur                          install aur packages                '
	@echo '   make dotfiles                     deploy dotfiles                     '
	@echo '   make suckless                     install suckless tools              '
	@echo '   make lunarvim                     install lunarvim                    '
	@echo '   make bashdash                     point /bin/sh to dash               '
	@echo '                                                                         '
	@echo 'All install commands are also available as clean commands to remove      '
	@echo 'installed files                                                          '
	@echo '                                                                         '
	@echo 'WARNING: MAKE SURE TO BACKUP YOUR CONFIGURATIONS!!!!                     '
	@echo '                                                                         '


all: base aur dotfiles suckless lunarvim bashdash
	@echo ""
	@echo "dotfiles - Making yourself at home"
	@echo "=================================="
	@echo ""
	@echo "All done."

clean:
	sudo rm -rfv ${HOME}/.config ${HOME}/.local/bin ${HOME}/.local/share/applications ${HOME}/.local/share/dotrice

setup:
	sudo timedatectl set-ntp true
	sudo hwclock --systohc
	sudo reflector -c Australia -c "New Zealand" -a 12 -p https -p http --sort rate --save /etc/pacman.d/mirrorlist
	sudo pacman -Sy

base:
	$(PACMAN) $(BASEPKGS) --ignore=xorg-xbacklight,xf86-video-vesa

aur:
	cd ${HOME}
	git clone https://aur.archlinux.org/paru-bin.git
	cd paru
	makepkg -si
	${PARU} ${AURPKGS}

dotfiles:
	git config --global credential.helper cache
	cd ${HOME}
	mkdir -p ${HOME}/.local/share/dotrice
	git clone --bare https://github.com/Elyk8/dotrice.git ${HOME}/.local/share/dotrice
	/usr/bin/git --git-dir=${HOME}/.local/share/dotrice --work-tree=${HOME} config --local status.showUntrackedFiles no
	/usr/bin/git --git-dir=${HOME}/.local/share/dotrice --work-tree=${HOME} checkout -f
	ln -sf ${HOME}/.config/shell/environment ${HOME}/.zshenv
	ln -sf ${HOME}/.config/zsh/.zprofile ${HOME}/.profile

suckless:
	mkdir -p ${HOME}/.local/src
	git clone https://github.com/Elyk8/dwm.git ${HOME}/.local/src/dwm
	git clone https://github.com/Elyk8/dwmblocks.git ${HOME}/.local/src/dwmblocks
	git clone https://github.com/Elyk8/dmenu.git ${HOME}/.local/src/dmenu
	git clone https://github.com/Elyk8/st.git ${HOME}/.local/src/st
	git clone https://github.com/Elyk8/sxiv.git ${HOME}/.local/src/sxiv
	git clone https://github.com/Elyk8/shotkey.git ${HOME}/.local/src/shotkey
	git clone https://github.com/Elyk8/touchcursor-linux.git ${HOME}/.local/src/touchcursor
	cd ${HOME}/.local/src/dwm && sudo make clean install
	cd ${HOME}/.local/src/dwmblocks && sudo make clean install
	cd ${HOME}/.local/src/dmenu && sudo make clean install
	cd ${HOME}/.local/src/st && sudo make clean install
	cd ${HOME}/.local/src/sxiv && sudo make clean install
	cd ${HOME}/.local/src/shotkey && sudo make clean install
	cd ${HOME}/.local/src/touchcursor && sudo make clean install

lunarvim:
	cd ${HOME}
	curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/rolling/utils/installer/install.sh | LVBRANCH=rolling bash -s -- --overwrite
	cd ${HOME}/.config
	rm -r lvim && git clone https://github.com/Elyk8/lvim.git

bashdash:
	cd ${HOME}
	${PACMAN} dash
	sudo ln -sfT /usr/bin/dash /usr/bin/sh
	cd ${HOME}/ricecooker
	sudo cp ./pachooks/bash-update.hook /usr/share/libalpm/hooks
