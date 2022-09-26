#!/bin/bash

# Update sources.list and update currently installed packages
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
sudo apt update ; sudo apt --yes upgrade

# Set Downloads directory path
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
downloads_path=$(xdg-user-dir DOWNLOAD)

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
	https://download.virtualbox.org/virtualbox/6.1.38/VBoxGuestAdditions_6.1.38.iso
sudo mkdir /media/iso
sudo mount --options loop "$downloads_path"/VBoxGuestAdditions_6.1.38.iso /media/iso
sudo bash /media/iso/VBoxLinuxAdditions.run --nox11
sudo umount /media/iso
