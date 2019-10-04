#!/bin/sh

set -e

TMAGENT_DATADIR=${TMAGENT_DATADIR:-/tmdata/data}
TMAGENT_LOGDIR=${TMAGENT_LOGDIR:-/tmdata/log}

# Fix permissions for the running environment
mkdir -p $TMAGENT_DATADIR
chown -R root:root $TMAGENT_DATADIR

mkdir -p $TMAGENT_LOGDIR
chown -R root:root $TMAGENT_LOGDIR

exit 0
