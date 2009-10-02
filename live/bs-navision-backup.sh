#! /bin/bash

STAMP=$(date +%Y-%m-%d-%H%M)
FROM_DIR="/mnt/glasgow/navision/"
TO_DIR="/mnt/london/bs/Navision/"$STAMP
TEMP_DIR="/mnt/london/bs/Navision/"


mkdir $TO_DIR

fs_remote=$(ls -l $FROM_DIR/database.fdb | awk '{print $5}')
rsync -a --no-whole-file -vv $FROM_DIR* $TEMP_DIR
fs_local=$(ls -l $TEMP_DIR/database.fdb | awk '{print $5}') 

cp $TEMP_DIR $TO_DIR

if [$fs_remote != $fs_local]; then
	echo "File seems to have changed size in transit:"
	echo "	Remote:	$fs_remote b"
	echo "	Local:	$fs_local b"
fi


echo $STAMP $fs_remote $fs_local >> ./bs-log

#cp $FROM_DIR* $TO_DIR


