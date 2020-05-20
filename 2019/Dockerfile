FROM  mcr.microsoft.com/mssql/server:2019-latest

LABEL vendor="SolutionSoft Systems, Inc"
LABEL maintainer="kzhao@solution-soft.com"

ARG S6_OVERLAY_VERSION="v2.0.0.1"
ARG TM_VERSION="12.9R3"

ARG DEFAULT_USER=time-traveler
ARG DEFAULT_HOME=/home/time-traveler

# This is mssql 2019 docker definition
ARG MSSQL_USER=10001
ARG MSSQL_GROUP=0	

ENV MSADMIN_USER=1000 \
    MSADMIN_GROUP=0	

ENV ACCEPT_EULA=Y \
    SA_PASSWORD=yourStrong(!)Password \
    MSSQL_PID=Express

ENV TM_LICHOST=172.0.0.1 \
    TM_LICPORT=57777 \
    TM_LICPASS=docker

ENV TMAGENT_DATADIR=/tmdata/data \
    TMAGENT_LOGDIR=/tmdata/log

# For installing software packages
USER root

ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz /tmp
COPY ./tmbase-${TM_VERSION}.tgz /tmp/tmbase.tgz
COPY ./build /
COPY ./install.sh /

RUN sh /install.sh && rm -f /install.sh

# Expose the ports we're interested in
EXPOSE 1433
EXPOSE 7800

VOLUME /tmdata
VOLUME /var/opt/mssql

ENTRYPOINT ["/init"]
