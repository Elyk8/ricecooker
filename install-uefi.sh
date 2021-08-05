#!/bin/bash

ln -sf /usr/share/zoneinfo/Australia/Victoria /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "FONT=ter-132n" > /etc/vconsole.conf
echo "skynet" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 skynet.localdomain skynet" >> /etc/hosts
echo root:hotsdad69 | chpasswd

# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm

pacman -S --noconfirm grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb dnsutils bluez bluez-utils cups alsa-utils pipewire pipewire-alsa pipewire-pulse bash-completion acpi acpi_call tlp ipset firewalld acpid os-prober ntfs-3g terminus-font

#pacman -S --noconfirm xf86-video-amdgpu
#pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
#pacman -S --noconfirm nvidia nvidia-utils nvidia-settings xf86-video-intel

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable acpid

useradd -m elyk
echo elyk:hotsdad69 | chpasswd
#usermod -aG libvirt elyk
usermod -aG video,audio elyk

echo "elyk ALL=(ALL) ALL" >> /etc/sudoers.d/elyk


printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
