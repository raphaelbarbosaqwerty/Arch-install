#!/bin/bash

#############################
# Automatized script to install Arch #
#       Version: 0.1                            #
#                                                      #
#############################

# Start # 
echo "1) Check your internet conection first!"
echo "2) Just start this script after arch-chroot"
echo ""
echo "this is script is just for this config"
echo "Intel I7 - HD Graphics 4000"
echo "Xorg - Xfce4 - LightDM"

# Language #
echo ""
echo "Language"
echo "Uncomment the line of your language"
nano /etc/locale.gen
locale-gen
echo "put your language inside this file EX: LANG=pt_BR.UTF-8"
sleep 3
nano /etc/locale.conf

# Time #
echo ""
echo "Time"
rm  /etc/localtime
ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc --utc

# Connection #
echo ""
echo "Config connection"
echo "Choose the name of your host"
sleep 3
nano /etc/hostname
nano /etc/hosts
echo "loading.."
sleep 2
pacman -S dhcpcd
systemctl enable dhcpcd

# Grub #
echo ""
echo "Grub config"
pacman -S grub os-prober
pacman -S grub os-prober intel-ucode
echo ""
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Rebooting #
exit
umount /mnt/home
umount /mnt
reboot
