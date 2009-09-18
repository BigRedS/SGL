#! /bin/bash

DIRNAME=$(date +%Y-%m-%d-%H%M)
FROM_DIR="/mnt/glasgow/navision"
TO_DIR="/mnt/london/bs/Navision/"$DIRNAME

#if [ -a $TO_DIR ]; then
#	exit 1;
#fi

mkdir $TO_DIR

cp -r $FROM_DIR $TO_DIR
