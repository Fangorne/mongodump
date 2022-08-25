#!/bin/bash

# Reset the crontab file, else the line below will be copied multiple times.
rm -f /etc/crontab
cp /etc/crontab.docker.orig /etc/crontab
echo "$BACKUP_CRON_TIME root MONGO_HOST_INT=$MONGO_HOST MONGO_PORT_INT=$MONGO_PORT MONGO_USER_INT=$MONGO_USER MONGO_PASSWORD_INT=$MONGO_PASSWORD KEEP_DAYS_INT=$KEEP_DAYS /usr/local/bin/mongoBackup.sh >/proc/1/fd/1 2>&1" >> /etc/crontab
exec ${@}
