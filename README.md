# bootstrap
Freebsd bootstrap script.

Adapted from Morgareth99:
https://gist.github.com/Morgareth99/d16bc411fad4040fde6ad1e3854052c9

An interactive script to bootstrap a clean Freebsd installation
to prepare it for Ansible(-pull) to complete the installation.

Performs:
  - freebsd-update fetch install
  - update pkg index
  - create local user
  - install Git-lite
  - install Ansible

fetch https://raw.githubusercontent.com/crispinon/bootstrap/main/bootstrap-bsd.sh
