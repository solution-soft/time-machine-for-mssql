FROM  mcr.microsoft.com/mssql/server:2019-latest

LABEL vendor="SolutionSoft Systems, Inc"
LABEL maintainer="kzhao@solution-soft.com"

ARG S6_OVERLAY_VERSION="v2.0.0.1"
ARG TM_VERSION="12.9R3"

ARG DEFAULT_USER=time-traveler
ARG DEFAULT_HOME=/home/time-traveler

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

RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && rm -f /tmp/s6-overlay-amd64.tar.gz \
&&  tar xzf /tmp/tmbase.tgz -C / && rm -f /tmp/tmbase.tgz \
&&  apt-get update && apt-get install -y --no-install-recommends iproute2 \
&&  rm -rf /var/lib/apt/lists/* \
&&  mkdir -p /tmdata /var/opt/mssql \
&&  useradd -r -m -d ${DEFAULT_HOME} -s /bin/bash -c "Default Time Travel User" ${DEFAULT_USER} \
&&  echo '/etc/ssstm/lib64/libssstm.so.1.0' >> /etc/ld.so.preload

# Expose the ports we're interested in
EXPOSE 1433
EXPOSE 7800

VOLUME /tmdata
VOLUME /var/opt/mssql

ENTRYPOINT ["/init"]
