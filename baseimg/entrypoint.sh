#!/bin/bash

set -e
set -u

# Run startup scripts

if [ -d /inittasks ] && [ "$(ls /inittasks/*.sh)" ]; then
  for init in /inittasks/*.sh; do
    sh $init
  done
  # prevent the init scripts from running again
  rm -f /inittasks/*.sh
fi

# If we have an interactive container
if [[ -t 0 || -p /dev/stdin ]]; then
    export PS1='[\u@\h : \w]\$ '
  if [[ $@ ]]; then 
    eval "exec $@"
  else 
    exec /bin/bash
  fi

# If container is detached run superviord in the foreground 
else
  if [[ $@ ]]; then 
    eval "exec $@"
  else 
    exec /usr/bin/supervisord -c /etc/supervisord.conf
  fi
fi
