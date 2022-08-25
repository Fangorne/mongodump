#! /bin/bash
TIMESTAMP=$(date +"%F_%H.%M.%S")
BACKUP_DIR="/backup"

BACKUPFILENAME="mongodump_"
BACKUPFILENAME+=$TIMESTAMP
BACKUPFILENAME+=".gz"

echo "Starting backup of MongoDB to file ${BACKUPFILENAME}"
echo "host ${MONGO_HOST_INT}"
echo "port ${MONGO_PORT_INT}"
echo "username ${MONGO_USER_INT}"
echo "password ${MONGO_PASSWORD_INT}"

cd $BACKUP_DIR

/usr/bin/mongodump --host $MONGO_HOST_INT:$MONGO_PORT_INT --username $MONGO_USER_INT --password $MONGO_PASSWORD_INT --gzip --archive=$BACKUPFILENAME
echo "Finished backup of MongoDB to file ${BACKUPFILENAME}"

# Delete old Backkupfiles
echo "Deleting fils 'mongodump_*.gz' older than ${KEEP_DAYS_INT} days."
find ./mongodump_*.gz -mtime +$KEEP_DAYS_INT -exec rm {} \;
echo "Done."

