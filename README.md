# Time Machine for Microsoft SQL Server in docker

SolutionSoft Systems, Inc. has released the docker image to enable time travel in the [Linux based container](https://hub.docker.com/r/microsoft/mssql-server-linux) for Microsoft SQL Server. You can pull the prebuilt [docker image](https://hub.docker.com/r/solutionsoft/time-machine-for-mssql) from docker hub.

This docker image is constructed on top of the Microsoft SQL Server for linux image.  Two additional running programs are included:

1. `tmlicd`, the license service daemon which communicates with the SolutionSoft Floating License Server, and
2. `tmagent`, the Time Machine agent which allows virtual clock manipulation from remote, using tools such as Time Machine Console, and Sync Server.

When the container starts, daemon `supervisord` will be spawned to manage all these running programs.

In constructing this image, we made the decision to run Microsoft SQL Server as the user `msadmin`. By default, user `msadmin` has the UID 999 and GID 0. One can easily change the UID and GID values for user `msadmin` through the environment variables `MSADMIN_UID` and `MSADMIN_GID`.  

To enable Time Machine functions, one need to inform the container the parameters of the floating license server.  These parameters are:

1. License server IP address;
2. License server listening port; and
3. License server token.

All these parameters can be defined by the environment variables `TM_LICHOST`, `TM_LICPORT` and `TM_LICPASS`.

The following is a sample docker compose `YML` file for running the container:

```
version: "3"
services:
  db:
    image: solutionsoft/time-machine-for-mssql:latest
    restart: always
    environment:
      MSADMIN_USER: "1000"
      MSADMIN_GROUP: "0"
      SA_PASSWORD: "demo$ite"
      TM_LICHOST: "192.168.20.40"
      TM_LICPORT: "57777"
      TM_LICPASS: "docker"
    ports:
      - "17800:7800"
      - "1433:1433"
    volumes:
      - "./tmdata:/tmdata"
      - "./mssql:/var/opt/mssql"
```

The UID to run Microsoft SQL Server is set to be 1000.  The floating license server IP is `192.168.20.40`, listening port is `57777` and the passcode/token is `docker`.

Time Machine agent will listen to port `7800`.  In our sample, this port is mapped to port `17800` and SQL Server port `1433` is mapped to `1433` in the host machine.

For dertails, please refer to the github repo at: [https://github.com/solution-soft/time-machine-for-mssql](https://github.com/solution-soft/time-machine-for-mssql).