#!/bin/bash

set -e

MSSQL_HOME=/var/opt/mssql
MSADMIN_UID=${MSADMIN_USER:-999}
MSADMIN_GID=${MSADMIN_GROUP:-0}

# Create MSSQL home if it does not exist
[ -d $MSSQL_HOME ] || mkdir -p $MSSQL_HOME

# Make sure there is enough RAM
avail=`free -g -t | grep Mem | awk '{ print $7}'`
if [[ $avail < "2" ]]; then
  echo "[Error] There is not enough free mem to run Microsoft MSSQL server!"
  exit 1
fi

# Create the admin user
getent passwd $MSADMIN_UID && userdel -f `id -u $MSADMIN_UID -n`
useradd -u $MSADMIN_UID -g $MSADMIN_GID -s /bin/bash -d /tmp msadmin

# Fix permissions for the DB working environment
chown -R $MSADMIN_UID:$MSADMIN_GID $MSSQL_HOME
chmod 770 $MSSQL_HOME
