#!/bin/bash

######################################
# Automatized script to install Arch #
#       Version: 1.0.1               #
######################################

# Start # 
echo "1) Check your internet conection first!"
echo "2) Just start this script after arch-chroot"
	sleep 2
clear

echo "Starting with the installationg becareful with all commands you choose..."
	sleep 2

echo "Config Hostname and hosts"

echo "Hostname?"
	read hostname
echo "Hosts?
	read hosts

echo "Config settings for your computer?"
	echo "Intel = 1"
	echo "Amd = 0"
	read intamd
clear

echo "Using laptop?"
	echo "Yes = 1"
	echo "No = 0"
	read note
clear

echo "Graphics card?"
	echo "ATI/AMD = 0"
	echo "Intel = 1"
	echo "Nvidia = 2"
	echo "Virutalbox = 3"
	read cardboard
clear

echo "Graphical ambient?"
	echo "Gnome = 0"
	echo "Xfce4 = 1"
	echo "KDE = 2"
	echo "Mate = 3"
	read grabient
clear

echo "Display Manager choose?"
	echo "GDM = 0"
	echo "Lightdm = 1"
	echo "SDDM = 2"
	echo "LXDM = 3"
	read disp
clear

# Language #
echo "Language"
echo "Uncomment the line of your language"
	nano /etc/locale.gen
	locale-gen
echo "choose your language inside this file EX: LANG=pt_BR.UTF-8. [If you understand press Enter]"
	read
	nano /etc/locale.conf
clear

# Time #
echo "Time and date, waiting.."
	rm  /etc/localtime
	ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
	hwclock --systohc --utc
clear

# Connection #
echo "Config connection"
echo "Choose the name of your host. [If you understand press Enter]"
	read
	echo "$hostname" > /etc/hostname
	echo "$hosts" > /etc/hosts
	echo "loading.."
	sleep 2
	pacman -S dhcpcd --noconfirm
	systemctl enable dhcpcd
clear

# Grub #
echo "Grub config"
	if (($intamd == 1))
		then
			pacman -S grub os-prober intel-ucode --noconfirm
		else
			pacman -S grub os-prober --noconfirm
	fi
	sleep 2
clear

echo "Grub setup waiting..."
	grub-install /dev/sda
	grub-mkconfig -o /boot/grub/grub.cfg
clear

# Config computer specs #
echo "Installing Wi-fi"
	pacman -S networkmanager net-tools --noconfirm
	systemctl enable NetworkManager
clear

echo "Connection Manager"
	pacman -S network-manager-applet --noconfirm
clear

# Using notebook #
echo "Packages for latptop waiting.."
	if (($note == 1))
		then
			pacman -S xf86-input-synaptics --noconfirm
			clear
		else
			clear
	fi

# Graphics card #
echo "Graphic setup waiting.."
	if (($cardboard == 0))
		then
			pacman -S xf86-video-amdgpu --noconfirm
				elif (($cardboard == 1))
				then
					pacman -S xf86-video-intel --noconfirm
				elif (($cardboard == 2))
				then
					pacman -S xf86-video-nouveau --noconfirm
				elif (($cardboard == 3))
				then	
					pacman -S xf86-video-fbdev virtualbox-guest-utils virtualbox-guest-modules-arch --noconfirm
				else
					echo "Error"
		sleep 3
	fi
clear

# Xorg #
echo "Xorg install waiting.."
	sleep 1
	pacman -S xorg-server xorg-xinit xorg-apps gvfs-mtp sshfs --noconfirm
clear

# Audio #
echo "Config audio waiting.."
	pacman -S pavucontrol alsa-firmware alsa-utils alsa-plugins pulseaudio-alsa pulseaudio --noconfirm
clear

# Keyboard #
echo "Keyboard to BR-ABNT2"
	localectl set-x11-keymap br abnt2

# Graphical interface #
echo "Graphical ambient setup waiting.."
	if (($grabient == 0)) #GNOME
		then
			pacman -S gnome gnome-extra --noconfirm
				elif (($grabient == 1)) #XFCE4 <3
				then	
					pacman -S xfce4 xfce4-goodies --noconfirm
				elif (($grabient == 2)) #KDE
				then	
					pacman -S plasma --noconfirm
				elif (($grabient == 3)) #MATE
				then	
					pacman -S mate mate-extra --noconfirm
		else
			echo "Error"
			sleep 3
	fi
clear

# Display Manager #
echo "Display manager setup waiting..."
if (($disp == 0)) #GDM
	then
		pacman -S gdm --noconfirm
		systemctl enable gdm
			elif (($disp == 1)) #LIGHTDM
			then	
				pacman -S lightdm lightdm-gtk-greeter --noconfirm
				pacman -S light-gtk-greeter-settings --noconfirm
				systemctl enable lightdm
			elif (($disp == 2)) #SDDM
			then
				pacman -S sddm --noconfirm
				systemctl enable sddm
			elif (($disp == 3)) #LXDM
			then
				pacman -S lxdm --noconfirm
				systemctl enable lxdm
	else
		echo "Error!"
		sleep 3
fi

# Users #
echo "New password root?"
	passwd
	clear

echo "New normal user name?"
	read name
	useradd -m -g users -G wheel,storage,power -s /bin/bash $name
	clear
	echo "New user password?"
	passwd $name
	clear
	echo "Edit file, uncoment line #%wheel all=(all)all, wait.. [If you understand press Enter]"
	read
	nano /etc/sudoers
	clear

# Rebooting #
echo "Now you need to reboot the computer and remove the drive media."
	echo "use this commands when the script end:"
	echo "exit"
	echo "umount /mnt/home"
	echo "umount /mnt"
	echo "reboot"
exit
