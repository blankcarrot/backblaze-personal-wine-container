#!/bin/bash
set -x

install_bz_version="${INSTALL_BZ_VERSION:-8.0.1.595}"
install_bz_url="${INSTALL_BZ_URL:-https://secure.backblaze.com/api/install_backblaze?file=bzinstall-win32-${install_bz_version}.exe}"

if [[ ! -v REINSTALL_BZ && -f "/config/wine/drive_c/Program Files (x86)/Backblaze/bzbui.exe" ]]; then
else
  cd /config/wine/ || exit 1
  curl -L "$install_bz_url" --output "install_backblaze.exe"
  ls -la
  wine64 "install_backblaze.exe" &
  sleep infinity
fi