# MongoDB 5.0 Backup with docker-compose and cron

[![pipeline status](https://gitlab.projecttac.com/tarator/mongodump/badges/master/pipeline.svg)](https://gitlab.projecttac.com/tarator/mongodump/-/commits/master)

Read this [Blogppost](https://www.abenthung.it/2021/10/07/scheduled-mongodb-5-0-backup-with-docker-compose/) for a more detailed explaination on how to use the container.
## Container on hub.docker.io

https://hub.docker.com/r/tarator/mongodump

## Build the container

```
docker built -t mymongodump
```

## Docker-compose example file:

```
version: '3.1'
services:
  mongo:
    image: mongo:5.0
    restart: always
    volumes:
      - ./mongo_data:/data/db

  mongo-backup:
    image: tarator/mongodump:latest
    restart: always
    links:
      - mongo
    depends_on:
      - mongo
    volumes:
      - ./mongo_backup:/backup:rw
    environment:
      - MONGO_HOST=mongo
      - MONGO_PORT=27017
      - BACKUP_CRON_TIME=05 18 * * *
      - KEEP_DAYS=14

```

This creates a Dump of the complete MongoDB everyday at 18:05 (HeadsUp: Container-Time is UTC) in the directory ./mongo_backup. The filename of the backup looks like this: mongodump_2021-11-30_21.35.55.gz

## Restore backup

```
mongorestore --host localhost:27017 --gzip --archive=mongodump_2021-11-30_21.35.55.gz
```

Feel free to use and improve.
