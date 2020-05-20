#!/bin/sh

set -e
set -x

MSSQL_HOME=/var/opt/mssql
MSSQL_UID=${MSSQL_UID:-10001}
MSSQL_GID=${MSSQL_GID:-0}

# extract S6-overlay image
if [ -f /tmp/s6-overlay-amd64.tar.gz ]; then
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C /;
    rm -f /tmp/s6-overlay-amd64.tar.gz
fi

# extract Time Machine image
if [ -f /tmp/tmbase.tgz ]; then
    tar xzf /tmp/tmbase.tgz -C /;
    rm -f /tmp/tmbase.tgz;
fi

# install iproute2 package for ubuntu
apt-get update;
apt-get install -y --no-install-recommends iproute2;
apt-get autoremove --purge;
apt-get clean;
rm -rf /var/lib/apt/lists/*

# create Time Machine and MSSQL data directories
mkdir -p /tmdata /var/opt/mssql

# create user 'mssql'
cnt=$(getent passwd $MSSQL_UID | wc -l)
if [ $cnt -gt 0 ]; then
    username=`id -u $MSSQL_UID -n`
    if [ ! $username = "mssql" ]; then
	useradd -u $MSSQL_UID -g $MSSQL_GID -s /bin/bash -d /var/opt/mssql mssql
    fi
else
    useradd -u $MSSQL_UID -g $MSSQL_GID -s /bin/bash -d /var/opt/mssql mssql
fi

# create user 'time-traveler'
cnt=$(id time-traveler | wc -l)
if [ $cnt -eq 0 ]; then
    useradd -d /tmp time-traveler
fi

# setup Time Machine preloading library
echo '/etc/ssstm/lib64/libssstm.so.1.0' >> /etc/ld.so.preload

exit 0
