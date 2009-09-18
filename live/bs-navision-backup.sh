#! /bin/bash

STAMP=$(date +%Y-%m-%d-%H%M)
FROM_DIR="/mnt/glasgow/navision/"
TO_DIR="/mnt/london/bs/Navision/"$STAMP
MD5_FILE=$TO_DIR/database.fdb.md5

mkdir $TO_DIR

#rsync -a -vv $FROM_DIR* $TO_DIR | mail -a "From: BS Backup" -s "BS Backup $date" avi.greenbury@servicegraphics.co.uk
cp $FROM_DIR* $TO_DIR
