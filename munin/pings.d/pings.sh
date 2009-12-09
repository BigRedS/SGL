#! /bin/bash

OUTPUT_FILE=/home/avi/bin/munin/pings.d/pinglog
TEMP_FILE=/home/avi/bin/munin/pings.d/pinglog.tmp

touch $TEMP_FILE $OUTPUT_FILE

for i in bs-svr02 hayes-svr02 notts-svr02 scan-svr01 service-svr23
do
	ping=$(ping -c 10 $i | tail -n 1 | awk '{print $4 }' | sed -e "s/\// /g")
	echo $i $ping >> $TEMP_FILE
done

mv $TEMP_FILE $OUTPUT_FILE
