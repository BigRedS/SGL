#! /bin/bash

source_file="/home/avi/bin/test/source"
dest_file="/mnt/london/ftp/avi_test"
dd_block_size=1024 # 1kb
dd_count=1024 # So we make a 1mb file


file_size=$(echo `du $source_file | awk '{ print $1 }'` *1024 | bc)

start=$(date +%s)
cp $source_file $dest_file
finish=$(date +%s)

cp_time=$(/usr/bin/time --format "%e" cp $source_file $dest_file 2&>1);

#cp_time=`echo $finish - $start | bc`
cp_rate=`echo $file_size / $cp_time | bc`



#echo "$start,$file_size,$cp_time,$cp_rate"
echo ": $cp_time :";

exit 0
