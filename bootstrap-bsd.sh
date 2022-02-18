#!/bin/sh

## fetch https://raw.githubusercontent.com/crispinon/bootstrap/main/bootstrap-bsd.sh
clear
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
    freebsd-update fetch install --not-running-from-cron
    printf "\nPlease reboot then re-run this script to continue...\n"
    exit
    ;;
esac

# Interactive package update
read -p "Do you want to check for and update package index? [y/N]: " answer
case $answer in
  [Yy]*)
    pkg bootstrap
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
      chown nico:nico /home/nico/.ssh/authorized_keys
      chmod 0600 /home/nico/.ssh/authorized_keys
      write_to_file 'git clone git@github.com:crispinon/ansible_pull.git
      ' /home/nico/ansible_pull.sh
      chown nico:nico /home/nico/ansible_pull.sh
      chmod 0755 /home/nico/ansible_pull.sh
    else echo "User Nico already exists!"
    fi
    ;;
esac

read -p "Do you want to install git-lite'? [y/N]: " answer
case $answer in
  [Yy]*)
    pkg install git-lite 
    ;;
esac

read -p "Do you want to install Ansible'? [y/N]: " answer
case $answer in
  [Yy]*)
    pkg install py38-ansible 
    ;;
esac

read -p "Press any key to continue..." 
case 1==1
  clear
  echo "Now copy your Github SSH private key to continue..."
  ;;
esac
