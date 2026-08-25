#!/bin/sh
set -e

sudo apt install scdaemon pcscd libccid libu2f-udev pcsc-tools yubikey-manager -y

sudo systemctl enable --now pcscd.socket

# gpg's built-in CCID driver and pcscd fight over the reader, so route gpg through pcscd
mkdir -p "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg"
grep -qxF 'disable-ccid' "$HOME/.gnupg/scdaemon.conf" 2>/dev/null ||
  echo 'disable-ccid' >>"$HOME/.gnupg/scdaemon.conf"

gpgconf --kill scdaemon gpg-agent
