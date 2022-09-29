#!/bin/bash
set -x

install_bz_version="${INSTALL_BZ_VERSION:-8.0.1.595}"
install_bz_url="${INSTALL_BZ_URL:-https://secure.backblaze.com/api/install_backblaze?file=bzinstall-win32-${install_bz_version}.exe}"

if [[ ${REINSTALL_BZ:-0} -eq 1 || ! -f "/config/wine/drive_c/Program Files (x86)/Backblaze/bzbui.exe" ]]; then
  cd /config/wine/ || exit 1
  curl -L "$install_bz_url" --output "install_backblaze.exe"
  ls -la
  wine64 "install_backblaze.exe" &
  sleep infinity
else
  for d in /data/*; do
    n="$(basename "$d")"
    l="${n//__*/}"
    if ! [[ $l =~ ^[d-y]$ ]]; then
      echo "invalid data directory: $d"
      exit 1
    fi
    t="/config/wine/dosdevices/$l:"
    if [[ -L "$t" ]]; then
      rm -v "$t"
    fi
    if [[ -e "$t" ]]; then
      echo "drive letter for $d already exists: $t"
      exit 1
    fi
    ln -vs "$d" "$t"
  done
  wine64 "/config/wine/drive_c/Program Files (x86)/Backblaze/bzbui.exe" -noqiet &
  sleep infinity
fi
