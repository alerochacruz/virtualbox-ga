#!/bin/bash

# Update sources.list and update currently installed packages
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
sudo apt update ; sudo apt --yes upgrade

# Set Downloads directory path
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
downloads_path=$(xdg-user-dir DOWNLOAD)

# Set VirtualBox version
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
version="6.1.40"

# Install VirtualBox Guest Additions requirements
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
sudo apt --yes install \
	build-essential \
	dkms \
	linux-headers-"$(uname --kernel-release)" \
	wget

# Install VirtualBox Guest Additions
# https://download.virtualbox.org/virtualbox/
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
wget --directory-prefix "$downloads_path" \
	https://download.virtualbox.org/virtualbox/"$version"/VBoxGuestAdditions_"$version".iso
sudo mkdir /media/iso
sudo mount --options loop "$downloads_path"/VBoxGuestAdditions_"$version".iso /media/iso
sudo bash /media/iso/VBoxLinuxAdditions.run --nox11
sudo umount /media/iso
