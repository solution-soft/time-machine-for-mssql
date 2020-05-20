#!/bin/bash

set -e

MSSQL_HOME=/var/opt/mssql
MSSQL_UID=${MSSQL_UID:-10001}
MSSQL_GID=${MSSQL_GID:-0}

# Make sure there is enough RAM
avail=`free -g -t | grep Mem | awk '{ print $7}'`
if [ $avail -lt 2 ]; then
  echo "[Error] There is not enough free mem to run Microsoft MSSQL server!"
  exit 1
fi

# correct permission setting
chown -R mssql $MSSQL_HOME

exit 0
