#!/bin/sh

## fetch https://raw.githubusercontent.com/crispinon/bootstrap/main/bootstrap-bsd.sh

set -e

# Util functions
# write_to_file "string" filename
write_to_file () {
  printf "$1\n" >> $2
}

# Globals

VERSION="0.1"

# Check for root
if [ $(whoami) != 'root' ]; then
  printf "Please run as root"
  exit
fi

CURRENT_USER=$(logname)

# Interactive system update
read -p "Do you want to check for and install system updates? [y/N]: " answer
case $answer in
  [Yy]*)
    freebsd-update fetch install
    printf "\nPlease reboot then re-run this script to continue...\n"
    exit
    ;;
esac

# Interactive package update
read -p "Do you want to check for and update package index? [y/N]: " answer
case $answer in
  [Yy]*)
    pkg update
    pkg clean
    pkg version
    exit
    ;;
esac

# Make sure user Nico does not exist and create user.

read -p "Do you want to check for and create user 'Nico'? [y/N]: " answer
case $answer in
  [Yy]*)
    if [ "$(id -u nico)" != '501' ]; then
      pw useradd -n nico -u 501 -m -G wheel,operator -s /bin/sh -c Nico -w random
      passwd nico
      mkdir -p /home/nico/.ssh
      chown -R nico:nico /home/nico/.ssh
      chmod 0700 /home/nico/.ssh
      write_to_file 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJGFWo+jX5zfSkN72yzEL4cyV8EngfN5ph52Rvva+5Yp lan-crispinon-com
      ' /home/nico/.ssh/authorized_keys
      chmod 0600 /home/nico/.ssh/authorized_keys
    else echo "User Nico already exists!"
    fi
    ;;
esac

read -p "Do you want to check for and create user 'Ansible'? [y/N]: " answer
case $answer in
  [Yy]*)
    if [ "$(id -u ansible)" != '666' ]; then
      pw useradd -n ansible -u 666 -m -G wheel -s /usr/sbin/nologin -c 'Unpriviledged user for Ansible' -w random
      passwd ansible
    else echo "User 'Ansible' already exists!"
    fi
    ;;
esac
