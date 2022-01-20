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
USER_NICO=false
ANSIBLE=false

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

if [ "$USER_NICO" = true ]; then
  pw useradd -n test -u 502 -G wheel -s /bin/sh -c Nico -w random 
fi
