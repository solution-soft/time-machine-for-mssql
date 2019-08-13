FROM  solutionsoft/time-machine-for-centos7:latest AS build

FROM  mcr.microsoft.com/mssql/server:2017-latest

LABEL vendor="SolutionSoft Systems, Inc"
LABEL maintainer="kzhao@solution-soft.com"

ENV MSADMIN_USER=999 \
    MSADMIN_GROUP=0	

ENV ACCEPT_EULA Y
ENV SA_PASSWORD YOURPWDHERE

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=off

ENV LICHOST=172.0.0.1 \
    LICPORT=57777 \
    LICPASS=docker

ENV TM_VERSION=12.9R3 \
    TMAGENT_DATADIR=/tmdata/data \
    TMAGENT_LOGDIR=/tmdata/log

# For installing software packages
USER root

# -- install packages
RUN apt-get update \
&&  apt-get install -y --no-install-recommends supervisor \
&&  mkdir -p /tmdata /var/opt/mssql \
&&  rm -rf /var/lib/apt/lists/*

# -- copy files from the centos image
COPY --from=build /etc/ssstm /etc/ssstm
COPY --from=build /usr/local/bin/tmlicd /usr/local/bin/tmlicd
COPY config /
COPY preload /etc/ssstm/

# -- setup preloading
RUN  echo "/etc/ssstm/lib64/libssstm.so.1.0" > /etc/ld.so.preload

# Expose the ports we're interested in
EXPOSE 1433
EXPOSE 7800

VOLUME /tmdata
VOLUME /var/opt/mssql

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
