#!/bin/sh
set -e

# Util functions

show_help() {
  cat << EOT
usage: freebsd-bootstrap.sh [--gnome][--xfce][--vbox][--vmware]|[--help]
--gnome
  Install Gnome 3
--xfce
  Install XFCE
--vbox
  Include VirtualBox additions and config
--vmware
  Include VMWare additions and config
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
GNOME=false
XFCE=false
VBOX=false
VMWARE=false

while :; do
  case $1 in
    -h|-\?|--help)
        show_help
        exit
        ;;
    --gnome)
        echo "Installing Gnome 3"
        GNOME=true
        ;;
    --xfce)
        echo "Installing XFCE"
        XFCE=true
        ;;
    --vbox)
        echo "Using VirtualBox configuration"
        VBOX=true
        ;;
    --vmware)
        echo "Using VMWare configuration"
        VMWARE=true
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
if [ ! "$(kldstat -v | grep linux64)" ]; then
  kldload linux64
fi
