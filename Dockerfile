FROM  krallin/ubuntu-tini:xenial AS bootstrap

FROM  solutionsoft/time-machine-for-centos7:latest AS build

FROM  mcr.microsoft.com/mssql/server:2017-latest

LABEL vendor="SolutionSoft Systems, Inc"
LABEL maintainer="kzhao@solution-soft.com"

ENV MSADMIN_USER=1000 \
    MSADMIN_GROUP=0	

ENV ACCEPT_EULA Y
ENV SA_PASSWORD yourStrong(!)Password

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=off

ENV TM_LICHOST=172.0.0.1 \
    TM_LICPORT=57777 \
    TM_LICPASS=docker

ENV TMAGENT_DATADIR=/tmdata/data \
    TMAGENT_LOGDIR=/tmdata/log

# For installing software packages
USER root

# -- install packages
RUN apt-get update \
&&  apt-get install -y --no-install-recommends supervisor \
&&  mkdir -p /tmdata /var/opt/mssql \
&&  rm -rf /etc/supervisor* \
&&  rm -rf /var/lib/apt/lists/*

# -- copy from the build image
COPY --from=bootstrap /usr/bin/tini /usr/bin/tini
COPY --from=build /etc/ssstm /etc/ssstm
COPY --from=build /usr/local/bin/tmlicd /usr/local/bin/tmlicd

# -- copy from the local filesystem
COPY baseimg /

# Expose the ports we're interested in
EXPOSE 1433
EXPOSE 7800

VOLUME /tmdata
VOLUME /var/opt/mssql

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
