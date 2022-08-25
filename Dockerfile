FROM ubuntu
LABEL maintainer="Marc Ranchin <marcus_the@msn.com>"

# Setting timezone has no effect on 20.04
#ENV TIMEZONE=Europe/Vienna
#RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone

# You can overwrite these setting-parameters in the .env file
ENV BACKUP_CRON_TIME="12 9 * * *"
ENV MONGO_HOST=mongodb.fangorne.ddnsfree.com
ENV MONGO_PORT=27017
ENV MONGO_USER=mongodb
ENV MONGO_PASSWORD=mongodb

ENV KEEP_DAYS=30

RUN mkdir /backup
VOLUME /backup

ADD mongoBackup.sh /usr/local/bin/
RUN chmod 750 /usr/local/bin/mongoBackup.sh
ADD docker-entrypoint.sh /usr/local/bin/
RUN chmod 750 /usr/local/bin/docker-entrypoint.sh

# Install CRON
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        ca-certificates \
        cron \
        gnupg \
        wget

# Keep a copy of the original crontab-file, so that it can be restored, everytime the container starts
# (else the line which will be added by the docker-entrypoint will be copied multiple times on each system-start)
RUN cp /etc/crontab /etc/crontab.docker.orig

# Install MongoDB Tools 5.0 - https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add - 
RUN touch /etc/apt/sources.list.d/mongodb-org-5.0.list
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        mongodb-org-tools \
    && apt-get -y clean \
    && apt-get -y autoclean \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["cron", "-f", "-L 0"]