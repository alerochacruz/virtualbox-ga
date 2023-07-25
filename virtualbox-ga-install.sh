#!/bin/bash

set -euxo pipefail

# This script expects that you are working with the latest version of VirtualBox
# If you need another version you can specify it in this section, for example:
# vbox_ver=6.1.46
# ********************************************************************************************
# ********************************************************************************************

vbox_ver=false

# ********************************************************************************************


# Update sources.list and update currently installed packages
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
sudo apt update ; sudo apt --yes upgrade

# Create a temporary directory to download a ISO file
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
temp_dir=$(mktemp --directory -t vboxiso-XXXXXX)

# Install VirtualBox Guest Additions requirements
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
sudo apt --yes install \
  build-essential \
  dkms \
  linux-headers-"$(uname --kernel-release)" \
  curl \
  wget

# Function: retrieve the latest version number of VirtualBox
# --------------------------------------------------------------------------------------------
function check_vbox_latest_ver() {
    curl \
    --silent \
    --show-error \
    --fail \
    https://download.virtualbox.org/virtualbox/ \
    | sed --quiet 's/.*href="\([^"]*\).*/\1/p' \
    | sed --quiet 's/\/*$//g' \
    | grep --invert-match '[[:alpha:]]' \
    | sort --version-sort \
    | tail --lines 1
} 

# Function: download the Guest Additions ISO, mount it and run the installer
# --------------------------------------------------------------------------------------------
function install_guest_additions() {
  version="$1"

  wget --directory-prefix "$temp_dir" \
    https://download.virtualbox.org/virtualbox/"$version"/VBoxGuestAdditions_"$version".iso

  sudo mkdir --parents /media/iso
  sudo mount --options loop "$temp_dir"/VBoxGuestAdditions_"$version".iso /media/iso
  sudo bash /media/iso/VBoxLinuxAdditions.run --nox11
  sudo umount /media/iso
}

# Install VirtualBox Guest Additions
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
vbox_latest=$(check_vbox_latest_ver)

if [[ "$vbox_ver" = false ]]; then
  install_guest_additions "$vbox_latest"
else
  install_guest_additions "$vbox_ver"
fi

