#!/bin/sh

## curl https://raw.githubusercontent.com/crispinon/bootstrap/main/freebsd.sh | /bin/sh

set -e

# Util functions

show_help() {
  cat << EOT
usage: freebsd-bootstrap.sh [--user_nico][--ansible][--help]
--user_nico
  Create user Nico
--ansible
  Install Ansible
--help
  This help
EOT
}

# write_to_file "string" filename
write_to_file () {
  printf "$1\n" >> $2
}

# Globals

VERSION="0.1"
USER_NICO=true
USER_ANSIBLE=true
ANSIBLE=true

while :; do
  case $1 in
    -h|-\?|--help)
        show_help
        exit
        ;;
    --user_nico)
        echo "Creating user Nico"
        USER_NICO=true
        ;;
    --user_ansible)
        echo "Creating user Nico"
        USER_ANSIBLE=true
        ;;
    --ANSIBLE)
        echo "Installing Ansible"
        ANSIBLE=true
        ;;
    --) # End of all options.
        shift
        break
        ;;
    -?*)
        printf 'Unknown option (ignored): %s\n' "$1" >&2
        ;;
    *) # Default case: No more options, so break out of the loop.
        break
  esac

  shift
done

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

# Load linux if not already
#if [ ! "$(kldstat -v | grep linux64)" ]; then
#  kldload linux64
#fi

# Make sure user Nico does not exist and create user.

read -p "Do you want to check for and create user 'Nico'? [y/N]: " answer
case $answer in
  [Yy]*)
    if [ "$USER_NICO" = true ] && [ "$(id -u nico)" != '501' ]; then
      pw useradd -n nico -u 501 -G wheel -s /bin/sh -c Nico -w random
      passwd nico
    else echo "User Nico already exists!"
    fi
    ;;
esac

read -p "Do you want to check for and create user 'Ansible'? [y/N]: " answer
case $answer in
  [Yy]*)
    if [ "$USER_ANSIBLE" = true ] && [ "$(id -u ansible)" != '666' ]; then
      pw useradd -n ansible -u 666 -G wheel -s /bin/sh -c Ansible -w random
      passwd ansible
    else echo "User 'Ansible' already exists!"
    fi
    ;;
esac
