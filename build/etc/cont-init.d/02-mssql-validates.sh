#!/usr/bin/with-contenv sh

set -e

# Make sure there is enough RAM
avail=`free -g -t | grep Mem | awk '{ print $7}'`
if [ $avail -lt 2 ]; then
  echo "[Error] There is not enough free mem to run Microsoft MSSQL server!"
  exit 1
fi

exit 0
